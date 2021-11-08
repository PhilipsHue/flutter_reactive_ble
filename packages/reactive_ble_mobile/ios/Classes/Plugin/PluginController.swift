import class CoreBluetooth.CBUUID
import class CoreBluetooth.CBService
import enum CoreBluetooth.CBManagerState
import var CoreBluetooth.CBAdvertisementDataServiceDataKey
import var CoreBluetooth.CBAdvertisementDataServiceUUIDsKey
import var CoreBluetooth.CBAdvertisementDataManufacturerDataKey
import var CoreBluetooth.CBAdvertisementDataLocalNameKey

final class PluginController {

    struct Scan {
        let services: [CBUUID]
    }

    private var central: Central?
    private var scan: StreamingTask<Scan>?
    var stateSink: EventSink? {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.reportState()
            }
        }
    }
    var messageQueue: [CharacteristicValueInfo] = [];
    var connectedDeviceSink: EventSink?
    var characteristicValueUpdateSink: EventSink?

    func initialize(name: String, completion: @escaping PlatformMethodCompletionHandler) {
        if let central = central {
            central.stopScan()
            central.disconnectAll()
        }

        central = Central(
            onStateChange: papply(weak: self) { context, _, state in
                context.reportState(state)
            },
            onDiscovery: papply(weak: self) { context, _, peripheral, advertisementData, rssi in
                guard let sink = context.scan?.sink
                else { assert(false); return }

                let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? ServiceData ?? [:]
                let serviceUuids = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] ?? []
                let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data ?? Data();
                let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? peripheral.name ?? String();

                let deviceDiscoveryMessage = DeviceScanInfo.with {
                    $0.id = peripheral.identifier.uuidString
                    $0.name = name
                    $0.rssi = Int32(rssi)
                    $0.serviceData = serviceData
                        .map { entry in
                            ServiceDataEntry.with {
                                $0.serviceUuid = Uuid.with { $0.data = entry.key.data }
                                $0.data = entry.value
                            }
                        }
                    $0.serviceUuids = serviceUuids.map { entry in Uuid.with { $0.data = entry.data }}
                    $0.manufacturerData = manufacturerData
                }

                sink.add(.success(deviceDiscoveryMessage))
            },
            onConnectionChange: papply(weak: self) { context, central, peripheral, change in
                let failure: (code: ConnectionFailure, message: String)?

                switch change {
                case .connected:
                    // Wait for services & characteristics to be discovered
                    return
                case .failedToConnect(let underlyingError), .disconnected(let underlyingError):
                    failure = underlyingError.map { (.failedToConnect, "\($0)") }
                }

                let message = DeviceInfo.with {
                    $0.id = peripheral.identifier.uuidString
                    $0.connectionState = encode(peripheral.state)
                    if let error = failure {
                        $0.failure = GenericFailure.with {
                            $0.code = Int32(error.code.rawValue)
                            $0.message = error.message
                        }
                    }
                }

                context.connectedDeviceSink?.add(.success(message))
            },
            onServicesWithCharacteristicsInitialDiscovery: papply(weak: self) { context, central, peripheral, errors in
                guard let sink = context.connectedDeviceSink
                else { assert(false); return }

                let message = DeviceInfo.with {
                    $0.id = peripheral.identifier.uuidString
                    $0.connectionState = encode(peripheral.state)
                    if !errors.isEmpty {
                        $0.failure = GenericFailure.with {
                            $0.code = Int32(ConnectionFailure.unknown.rawValue)
                            $0.message = errors.map(String.init(describing:)).joined(separator: "\n")
                        }
                    }
                }

                sink.add(.success(message))
            },
            onCharacteristicValueUpdate: papply(weak: self) { context, central, characteristic, value, error in
                let message = CharacteristicValueInfo.with {
                    $0.characteristic = CharacteristicAddress.with {
                        $0.characteristicUuid = Uuid.with { $0.data = characteristic.id.data }
                        $0.serviceUuid = Uuid.with { $0.data = characteristic.serviceID.data }
                        $0.deviceID = characteristic.peripheralID.uuidString
                    }
                    if let value = value {
                        $0.value = value
                    }
                    if let error = error {
                        $0.failure = GenericFailure.with {
                            $0.code = Int32(CharacteristicValueUpdateFailure.unknown.rawValue)
                            $0.message = "\(error)"
                        }
                    }
                }
                let sink = context.characteristicValueUpdateSink
                if (sink != nil) {
                    sink!.add(.success(message))
                } else {
                    // In case message arrives before sink is created
                    context.messageQueue.append(message);
                }

            }
        )

        completion(.success(nil))
    }

    func deinitialize(name: String, completion: @escaping PlatformMethodCompletionHandler) {
        guard let central = central
        else {
            completion(.failure(PluginError.notInitialized.asFlutterError))
            return
        }

        central.stopScan()
        central.disconnectAll()

        self.central = nil

        completion(.success(nil))
    }

    func scanForDevices(name: String, args: ScanForDevicesRequest, completion: @escaping PlatformMethodCompletionHandler) {
        guard let central = central
        else {
            completion(.failure(PluginError.notInitialized.asFlutterError))
            return
        }

        assert(!central.isScanning)

        scan = StreamingTask(parameters: .init(services: args.serviceUuids.map({ uuid in CBUUID(data: uuid.data) })))

        completion(.success(nil))
    }

    func startScanning(sink: EventSink) -> FlutterError? {
        guard let central = central
        else { return PluginError.notInitialized.asFlutterError }

        guard let scan = scan
        else { return PluginError.internalInconcictency(details: "a scanning task has not been initialized yet, but a client has subscribed").asFlutterError }

        self.scan = scan.with(sink: sink)

        central.scanForDevices(with: scan.parameters.services)

        return nil
    }

    func stopScanning() -> FlutterError? {
        central?.stopScan()
        return nil
    }

    func connectToDevice(name: String, args: ConnectToDeviceRequest, completion: @escaping PlatformMethodCompletionHandler) {
        guard let central = central
        else {
            completion(.failure(PluginError.notInitialized.asFlutterError))
            return
        }

        guard let deviceID = UUID(uuidString: args.deviceID)
        else {
            completion(.failure(PluginError.invalidMethodCall(method: name, details: "\"deviceID\" is invalid").asFlutterError))
            return
        }

        let servicesWithCharacteristicsToDiscover: ServicesWithCharacteristicsToDiscover
        if args.hasServicesWithCharacteristicsToDiscover {
            let items = args.servicesWithCharacteristicsToDiscover.items.reduce(
                into: [ServiceID: [CharacteristicID]](),
                { dict, item in
                    let serviceID = CBUUID(data: item.serviceID.data)
                    let characteristicIDs = item.characteristics.map { CBUUID(data: $0.data) }

                    dict[serviceID] = characteristicIDs
                }
            )
            servicesWithCharacteristicsToDiscover = ServicesWithCharacteristicsToDiscover.some(items.mapValues(CharacteristicsToDiscover.some))
        } else {
            servicesWithCharacteristicsToDiscover = .all
        }

        let timeout = args.timeoutInMs > 0 ? TimeInterval(args.timeoutInMs) / 1000 : nil

        completion(.success(nil))
        
        if let sink = connectedDeviceSink {
            let message = DeviceInfo.with {
                $0.id = args.deviceID
                $0.connectionState = encode(.connecting)
            }
            sink.add(.success(message))
        } else {
            print("Warning! No event channel set up to report a connection update")
        }
        
        do {
            try central.connect(
                to: deviceID,
                discover: servicesWithCharacteristicsToDiscover,
                timeout: timeout
            )
        } catch {
            guard let sink = connectedDeviceSink
            else {
                print("Warning! No event channel set up to report a connection failure: \(error)")
                return
            }

            let message = DeviceInfo.with {
                $0.id = args.deviceID
                $0.connectionState = encode(.disconnected)
                $0.failure = GenericFailure.with {
                    $0.code = Int32(ConnectionFailure.failedToConnect.rawValue)
                    $0.message = "\(error)"
                }
            }

            sink.add(.success(message))
        }
    }

    func disconnectFromDevice(name: String, args: ConnectToDeviceRequest, completion: @escaping PlatformMethodCompletionHandler) {
        guard let central = central
        else {
            completion(.failure(PluginError.notInitialized.asFlutterError))
            return
        }

        guard let deviceID = UUID(uuidString: args.deviceID)
        else {
            completion(.failure(PluginError.invalidMethodCall(method: name, details: "\"deviceID\" is invalid").asFlutterError))
            return
        }

        completion(.success(nil))

        central.disconnect(from: deviceID)
    }

    func discoverServices(name: String, args: DiscoverServicesRequest, completion: @escaping PlatformMethodCompletionHandler) {
        guard let central = central
        else {
            completion(.failure(PluginError.notInitialized.asFlutterError))
            return
        }

        guard let deviceID = UUID(uuidString: args.deviceID)
        else {
            completion(.failure(PluginError.invalidMethodCall(method: name, details: "\"deviceID\" is invalid").asFlutterError))
            return
        }

        func makeDiscoveredService(service: CBService) -> DiscoveredService {
            DiscoveredService.with {
                $0.serviceUuid = Uuid.with { $0.data = service.uuid.data }
                $0.characteristicUuids = (service.characteristics ?? []).map { characteristic in
                    Uuid.with { $0.data = characteristic.uuid.data }
                }
                $0.characteristics = (service.characteristics ?? []).map { characteristic in
                    DiscoveredCharacteristic.with{
                        $0.characteristicID = Uuid.with{$0.data = characteristic.uuid.data}
                        if characteristic.service?.uuid.data != nil {
                            $0.serviceID = Uuid.with{$0.data = characteristic.service!.uuid.data}
                        }
                        $0.isReadable = characteristic.properties.contains(.read)
                        $0.isWritableWithResponse = characteristic.properties.contains(.write)
                        $0.isWritableWithoutResponse = characteristic.properties.contains(.writeWithoutResponse)
                        $0.isNotifiable = characteristic.properties.contains(.notify)
                        $0.isIndicatable = characteristic.properties.contains(.indicate)
                    }
                }
 
                $0.includedServices = (service.includedServices ?? []).map(makeDiscoveredService)
            }
        }

        do {
            try central.discoverServicesWithCharacteristics(
                for: deviceID,
                discover: .all,
                completion: { central, peripheral, errors in
                    completion(.success(DiscoverServicesInfo.with {
                        $0.deviceID = deviceID.uuidString
                        $0.services = (peripheral.services ?? []).map(makeDiscoveredService)
                    }))
                }
            )
        } catch {
            completion(.failure(PluginError.unknown(error).asFlutterError))
        }
    }

    func enableCharacteristicNotifications(name: String, args: NotifyCharacteristicRequest, completion: @escaping PlatformMethodCompletionHandler) {
        guard let central = central
        else {
            completion(.failure(PluginError.notInitialized.asFlutterError))
            return
        }

        guard let characteristic = QualifiedCharacteristicIDFactory().make(from: args.characteristic)
        else {
            completion(.failure(PluginError.invalidMethodCall(method: name, details: "characteristic, service, and peripheral IDs are required").asFlutterError))
            return
        }

        do {
            try central.turnNotifications(.on, for: characteristic, completion: { _, error in
                if let error = error {
                    completion(.failure(PluginError.unknown(error).asFlutterError))
                } else {
                    completion(.success(nil))
                }
            })
        } catch {
            completion(.failure(PluginError.unknown(error).asFlutterError))
        }
    }

    func disableCharacteristicNotifications(name: String, args: NotifyNoMoreCharacteristicRequest, completion: @escaping PlatformMethodCompletionHandler) {
        guard let central = central
        else {
            completion(.failure(PluginError.notInitialized.asFlutterError))
            return
        }

        guard let characteristic = QualifiedCharacteristicIDFactory().make(from: args.characteristic)
        else {
            completion(.failure(PluginError.invalidMethodCall(method: name, details: "characteristic, service, and peripheral IDs are required").asFlutterError))
            return
        }

        do {
            try central.turnNotifications(.off, for: characteristic, completion: { _, error in
                if let error = error {
                    completion(.failure(PluginError.unknown(error).asFlutterError))
                } else {
                    completion(.success(nil))
                }
            })
        } catch {
            completion(.failure(PluginError.unknown(error).asFlutterError))
        }
    }

    func readCharacteristic(name: String, args: ReadCharacteristicRequest, completion: @escaping PlatformMethodCompletionHandler) {
        guard let central = central
        else {
            completion(.failure(PluginError.notInitialized.asFlutterError))
            return
        }

        guard let characteristic = QualifiedCharacteristicIDFactory().make(from: args.characteristic)
        else {
            completion(.failure(PluginError.invalidMethodCall(method: name, details: "characteristic, service, and peripheral IDs are required").asFlutterError))
            return
        }

        completion(.success(nil))

        do {
            try central.read(characteristic: characteristic)
        } catch {
            guard let sink = characteristicValueUpdateSink
            else {
                print("Warning! No subscription to report a characteristic read failure: \(error)")
                return
            }

            let message = CharacteristicValueInfo.with {
                $0.characteristic = args.characteristic
                $0.failure = GenericFailure.with {
                    $0.code = Int32(CharacteristicValueUpdateFailure.unknown.rawValue)
                    $0.message = "\(error)"
                }
            }
            sink.add(.success(message))
        }
    }

    func writeCharacteristicWithResponse(name: String, args: WriteCharacteristicRequest, completion: @escaping PlatformMethodCompletionHandler) {
        guard let central = central
        else {
            completion(.failure(PluginError.notInitialized.asFlutterError))
            return
        }

        guard let characteristic = QualifiedCharacteristicIDFactory().make(from: args.characteristic)
        else {
            completion(.failure(PluginError.invalidMethodCall(method: name, details: "characteristic, service, and peripheral IDs are required").asFlutterError))
            return
        }

        do {
            try central.writeWithResponse(
                value: args.value,
                characteristic: QualifiedCharacteristic(id: characteristic.id, serviceID: characteristic.serviceID, peripheralID: characteristic.peripheralID),
                completion: { _, characteristic, error in
                    let result = WriteCharacteristicInfo.with {
                        $0.characteristic = CharacteristicAddress.with {
                            $0.characteristicUuid = Uuid.with { $0.data = characteristic.id.data }
                            $0.serviceUuid = Uuid.with { $0.data = characteristic.serviceID.data }
                            $0.deviceID = characteristic.peripheralID.uuidString
                        }
                        if let error = error {
                            $0.failure = GenericFailure.with {
                                $0.code = Int32(WriteCharacteristicFailure.unknown.rawValue)
                                $0.message = "\(error)"
                            }
                        }
                    }

                    completion(.success(result))
                }
            )
        } catch {
            let result = WriteCharacteristicInfo.with {
                $0.characteristic = args.characteristic
                $0.failure = GenericFailure.with {
                    $0.code = Int32(WriteCharacteristicFailure.unknown.rawValue)
                    $0.message = "\(error)"
                }
            }

            completion(.success(result))
        }
    }
    
    func writeCharacteristicWithoutResponse(name: String, args: WriteCharacteristicRequest, completion: @escaping PlatformMethodCompletionHandler) {
        guard let central = central
        else {
            completion(.failure(PluginError.notInitialized.asFlutterError))
            return
        }
        
        guard let characteristic = QualifiedCharacteristicIDFactory().make(from: args.characteristic)
        else {
            completion(.failure(PluginError.invalidMethodCall(method: name, details: "characteristic, service, and peripheral IDs are required").asFlutterError))
            return
        }
        
        let result: WriteCharacteristicInfo
        do {
            try central.writeWithoutResponse(
                value: args.value,
                characteristic: QualifiedCharacteristic(id: characteristic.id, serviceID: characteristic.serviceID, peripheralID: characteristic.peripheralID)
            )
            result = WriteCharacteristicInfo.with {
                $0.characteristic = args.characteristic
            }
        } catch {
            result = WriteCharacteristicInfo.with {
                $0.characteristic = args.characteristic
                $0.failure = GenericFailure.with {
                    $0.code = Int32(WriteCharacteristicFailure.unknown.rawValue)
                    $0.message = "\(error)"
                }
            }
        }

        completion(.success(result))
    }

    func reportMaximumWriteValueLength(name: String, args: NegotiateMtuRequest, completion: @escaping PlatformMethodCompletionHandler) {
        guard let central = central
        else {
            completion(.failure(PluginError.notInitialized.asFlutterError))
            return
        }

        guard let peripheralID = UUID(uuidString: args.deviceID)
        else {
            completion(.failure(PluginError.invalidMethodCall(method: name, details: "peripheral ID is required").asFlutterError))
            return
        }

        let result: NegotiateMtuInfo
        do {
            let mtu = try central.maximumWriteValueLength(for: peripheralID, type: .withoutResponse)
            result = NegotiateMtuInfo.with {
                $0.deviceID = args.deviceID
                $0.mtuSize = Int32(mtu)
            }
        } catch {
            result = NegotiateMtuInfo.with {
                $0.deviceID = args.deviceID
                $0.failure = GenericFailure.with {
                    $0.code = Int32(MaximumWriteValueLengthRetrieval.unknown.rawValue)
                    $0.message = "\(error)"
                }
            }
        }

        completion(.success(result))
    }

    private func reportState(_ knownState: CBManagerState? = nil) {
        guard let sink = stateSink
        else { return }

        let stateToReport = knownState ?? central?.state ?? .unknown
        let message = BleStatusInfo.with { $0.status = encode(stateToReport) }

        sink.add(.success(message))
    }
}
