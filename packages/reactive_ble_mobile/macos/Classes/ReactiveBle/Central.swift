import CoreBluetooth

typealias RSSI = Int

typealias PeripheralID = UUID
typealias ServiceID = CBUUID
typealias CharacteristicID = CBUUID

typealias ServiceData = [ServiceID: Data]
typealias AdvertisementData = [String: Any]

final class Central {

    typealias StateChangeHandler = (Central, CBManagerState) -> Void
    typealias DiscoveryHandler = (Central, CBPeripheral, AdvertisementData, RSSI) -> Void
    typealias ConnectionChangeHandler = (Central, CBPeripheral, ConnectionChange) -> Void
    typealias ServicesWithCharacteristicsDiscoveryHandler = (Central, CBPeripheral, [Error]) -> Void
    typealias CharacteristicNotifyCompletionHandler = (Central, Error?) -> Void
    typealias CharacteristicValueUpdateHandler = (Central, QualifiedCharacteristic, Data?, Error?) -> Void
    typealias CharacteristicWriteCompletionHandler = (Central, QualifiedCharacteristic, Error?) -> Void

    private let onServicesWithCharacteristicsInitialDiscovery: ServicesWithCharacteristicsDiscoveryHandler

    private var peripheralDelegate: PeripheralDelegate!
    private var centralManagerDelegate: CentralManagerDelegate!
    private var centralManager: CBCentralManager!

    private(set) var isScanning = false
    private(set) var activePeripherals = [PeripheralID: CBPeripheral]()
    private(set) var connectRegistry = PeripheralTaskRegistry<ConnectTaskController>()
    private let servicesWithCharacteristicsDiscoveryRegistry = PeripheralTaskRegistry<ServicesWithCharacteristicsDiscoveryTaskController>()
    private let characteristicNotifyRegistry = PeripheralTaskRegistry<CharacteristicNotifyTaskController>()
    private let characteristicWriteRegistry = PeripheralTaskRegistry<CharacteristicWriteTaskController>()

    init(
        onStateChange: @escaping StateChangeHandler,
        onDiscovery: @escaping DiscoveryHandler,
        onConnectionChange: @escaping ConnectionChangeHandler,
        onServicesWithCharacteristicsInitialDiscovery: @escaping ServicesWithCharacteristicsDiscoveryHandler,
        onCharacteristicValueUpdate: @escaping CharacteristicValueUpdateHandler
    ) {
        self.onServicesWithCharacteristicsInitialDiscovery = onServicesWithCharacteristicsInitialDiscovery
        self.centralManagerDelegate = CentralManagerDelegate(
            onStateChange: papply(weak: self) { central, state in
                if state != .poweredOn {
                    central.activePeripherals.forEach { _, peripheral in
                        let error = Failure.notPoweredOn(actualState: state)
                        central.eject(peripheral, error: error)
                        onConnectionChange(central, peripheral, .disconnected(error))
                    }
                }
                onStateChange(central, state)
            },
            onDiscovery: papply(weak: self, onDiscovery),
            onConnectionChange: papply(weak: self) { central, peripheral, change in
                central.connectRegistry.updateTask(
                    key: peripheral.identifier,
                    action: { $0.handleConnectionChange(change) }
                )

                switch change {
                case .connected:
                    break
                case .failedToConnect(let error), .disconnected(let error):
                    central.eject(peripheral, error: error ?? PluginError.connectionLost)
                }

                onConnectionChange(central, peripheral, change)
            }
        )
        self.peripheralDelegate = PeripheralDelegate(
            onServicesDiscovery: papply(weak: self) { central, peripheral, error in
                central.servicesWithCharacteristicsDiscoveryRegistry.updateTask(
                    key: peripheral.identifier,
                    action: { $0.handleServicesDiscovery(peripheral: peripheral, error: error) }
                )
            },
            onCharacteristicsDiscovery: papply(weak: self) { central, service, error in
                central.servicesWithCharacteristicsDiscoveryRegistry.updateTask(
                    key: service.peripheral!.identifier,
                    action: { $0.handleCharacteristicsDiscovery(service: service, error: error) }
                )
            },
            onCharacteristicNotificationStateUpdate: papply(weak: self) { central, characteristic, error in
                central.characteristicNotifyRegistry.updateTask(
                    key: QualifiedCharacteristic(characteristic),
                    action: { $0.complete(error: error) }
                )
            },
            onCharacteristicValueUpdate: papply(weak: self) { central, characteristic, error in
                onCharacteristicValueUpdate(central, QualifiedCharacteristic(characteristic), characteristic.value, error)
            },
            onCharacteristicValueWrite: papply(weak: self) { central, characteristic, error in
                central.characteristicWriteRegistry.updateTask(
                    key: QualifiedCharacteristic(characteristic),
                    action: { $0.handleWrite(error: error) }
                )
            }
        )
        self.centralManager = CBCentralManager(
            delegate: centralManagerDelegate,
            queue: nil
        )
    }

    var state: CBManagerState { return centralManager.state }

    func scanForDevices(with services: [ServiceID]?) {
        isScanning = true
        centralManager.scanForPeripherals(
            withServices: services,
            options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        )
    }

    func stopScan() {
        centralManager.stopScan()
        isScanning = false
    }

    func connect(to peripheralID: PeripheralID, discover servicesWithCharacteristicsToDiscover: ServicesWithCharacteristicsToDiscover, timeout: TimeInterval?) throws {
        let peripheral = try resolve(known: peripheralID)

        peripheral.delegate = peripheralDelegate
        activePeripherals[peripheral.identifier] = peripheral

        connectRegistry.registerTask(
            key: peripheralID,
            params: .init(),
            timeout: timeout.map { timeout in (
                duration: timeout,
                handler: papply(weak: self) { (central: Central) -> Void in
                    central.disconnect(from: peripheralID)
                }
            )},
            completion: papply(weak: self) { central, connectionChange in
                switch connectionChange {
                case .connected:
                    peripheral.delegate = central.peripheralDelegate

                    central.discoverServicesWithCharacteristics(
                        for: peripheral,
                        discover: servicesWithCharacteristicsToDiscover,
                        completion: central.onServicesWithCharacteristicsInitialDiscovery
                    )
                case .failedToConnect(_), .disconnected(_):
                    break
                }
            }
        )

        connectRegistry.updateTask(
            key: peripheralID,
            action: { $0.connect(centralManager: centralManager, peripheral: peripheral) }
        )
    }

    func disconnect(from peripheralID: PeripheralID) {
        guard let peripheral = try? resolve(known: peripheralID)
        else { return }

        centralManager.cancelPeripheralConnection(peripheral)
    }

    func disconnectAll() {
        activePeripherals
            .values
            .forEach(centralManager.cancelPeripheralConnection)
    }

    func discoverServicesWithCharacteristics(
        for peripheralID: PeripheralID,
        discover servicesWithCharacteristicsToDiscover: ServicesWithCharacteristicsToDiscover,
        completion: @escaping ServicesWithCharacteristicsDiscoveryHandler
    ) throws -> Void {
        let peripheral = try resolve(connected: peripheralID)

        discoverServicesWithCharacteristics(
            for: peripheral,
            discover: servicesWithCharacteristicsToDiscover,
            completion: completion
        )
    }

    private func discoverServicesWithCharacteristics(
        for peripheral: CBPeripheral,
        discover servicesWithCharacteristicsToDiscover: ServicesWithCharacteristicsToDiscover,
        completion: @escaping ServicesWithCharacteristicsDiscoveryHandler
    ) -> Void {
        servicesWithCharacteristicsDiscoveryRegistry.registerTask(
            key: peripheral.identifier,
            params: .init(servicesWithCharacteristicsToDiscover: servicesWithCharacteristicsToDiscover),
            completion: papply(weak: self) { central, result in
                completion(central, peripheral, result)
            }
        )
        servicesWithCharacteristicsDiscoveryRegistry.updateTask(
            key: peripheral.identifier,
            action: { $0.start(peripheral: peripheral) }
        )
    }

    func turnNotifications(_ state: OnOff, for qualifiedCharacteristic: QualifiedCharacteristic, completion: @escaping CharacteristicNotifyCompletionHandler) throws {
        let characteristic = try resolve(characteristic: qualifiedCharacteristic)

        guard [CBCharacteristicProperties.notify, .notifyEncryptionRequired, .indicate, .indicateEncryptionRequired]
                .contains(where: characteristic.properties.contains)
        else { throw Failure.notificationsNotSupported(qualifiedCharacteristic) }

        characteristicNotifyRegistry.registerTask(
            key: qualifiedCharacteristic,
            params: .init(state: state),
            completion: papply(weak: self) { central, result in
                completion(central, result)
            }
        )

        characteristicNotifyRegistry.updateTask(
            key: qualifiedCharacteristic,
            action: { $0.start(characteristic: characteristic) }
        )
    }

    func read(characteristic qualifiedCharacteristic: QualifiedCharacteristic) throws {
        let characteristic = try resolve(characteristic: qualifiedCharacteristic)

        guard characteristic.properties.contains(.read)
        else { throw Failure.notReadable(qualifiedCharacteristic) }
        
        guard let peripheral = characteristic.service?.peripheral
        else { throw Failure.peripheralIsUnknown(qualifiedCharacteristic.peripheralID) }
        
        peripheral.readValue(for: characteristic)

    }

    func writeWithResponse(
        value: Data,
        characteristic qualifiedCharacteristic: QualifiedCharacteristic,
        completion: @escaping CharacteristicWriteCompletionHandler
    ) throws {
        let characteristic = try resolve(characteristic: qualifiedCharacteristic)

        guard characteristic.properties.contains(.write)
        else { throw Failure.notWritable(qualifiedCharacteristic) }

        characteristicWriteRegistry.registerTask(
            key: qualifiedCharacteristic,
            params: .init(value: value),
            completion: papply(weak: self) { central, error in
                completion(central, qualifiedCharacteristic, error)
            }
        )
        
        guard let peripheral = characteristic.service?.peripheral
        else{ throw Failure.peripheralIsUnknown(qualifiedCharacteristic.peripheralID) }

        characteristicWriteRegistry.updateTask(
            key: qualifiedCharacteristic,
            action: { $0.start(peripheral: peripheral) }
        )
    }
    
    func writeWithoutResponse(
        value: Data,
        characteristic qualifiedCharacteristic: QualifiedCharacteristic
    ) throws {
        let characteristic = try resolve(characteristic: qualifiedCharacteristic)

        guard characteristic.properties.contains(.writeWithoutResponse)
        else { throw Failure.notWritable(qualifiedCharacteristic) }
        
        guard let response = characteristic.service?.peripheral?.writeValue(value, for: characteristic, type: .withoutResponse)
        else { throw Failure.characteristicNotFound(qualifiedCharacteristic) }
        
        return response
    }

    func maximumWriteValueLength(for peripheral: PeripheralID, type: CBCharacteristicWriteType) throws -> Int {
        let peripheral = try resolve(connected: peripheral)
        return peripheral.maximumWriteValueLength(for: type)
    }

    private func eject(_ peripheral: CBPeripheral, error: Error) {
        peripheral.delegate = nil
        activePeripherals[peripheral.identifier] = nil

        servicesWithCharacteristicsDiscoveryRegistry.updateTasks(
            in: peripheral.identifier,
            action: { $0.cancel(error: error) }
        )
        characteristicNotifyRegistry.updateTasks(
            in: peripheral.identifier,
            action: { $0.cancel(error: error) }
        )
        characteristicWriteRegistry.updateTasks(
            in: peripheral.identifier,
            action: { $0.cancel(error: error) }
        )
    }

    private func resolve(known peripheralID: PeripheralID) throws -> CBPeripheral {
        guard let peripheral = centralManager.retrievePeripherals(withIdentifiers: [peripheralID]).first
        else { throw Failure.peripheralIsUnknown(peripheralID) }

        return peripheral
    }

    private func resolve(connected peripheralID: PeripheralID) throws -> CBPeripheral {
        guard let peripheral = activePeripherals[peripheralID]
        else { throw Failure.peripheralIsUnknown(peripheralID) }

        guard peripheral.state == .connected
        else { throw Failure.peripheralIsNotConnected(peripheralID) }

        return peripheral
    }

    private func resolve(characteristic qualifiedCharacteristic: QualifiedCharacteristic) throws -> CBCharacteristic {
        let peripheral = try resolve(connected: qualifiedCharacteristic.peripheralID)

        guard let service = peripheral.services?.first(where: { $0.uuid == qualifiedCharacteristic.serviceID })
        else { throw Failure.serviceNotFound(qualifiedCharacteristic.serviceID, qualifiedCharacteristic.peripheralID) }

        guard let characteristic = service.characteristics?.first(where: { $0.uuid == qualifiedCharacteristic.id })
        else { throw Failure.characteristicNotFound(qualifiedCharacteristic) }

        return characteristic
    }

    private enum Failure: Error, CustomStringConvertible {

        case notPoweredOn(actualState: CBManagerState)
        case peripheralIsUnknown(PeripheralID)
        case peripheralIsNotConnected(PeripheralID)
        case serviceNotFound(ServiceID, PeripheralID)
        case characteristicNotFound(QualifiedCharacteristic)
        case notificationsNotSupported(QualifiedCharacteristic)
        case notReadable(QualifiedCharacteristic)
        case notWritable(QualifiedCharacteristic)

        var description: String {
            switch self {
            case .notPoweredOn(let actualState):
                return "Bluetooth is not powered on (the current state code is \(actualState.rawValue))"
            case .peripheralIsUnknown(let peripheralID):
                return "A peripheral \(peripheralID.uuidString) is unknown (make sure it has been discovered)"
            case .peripheralIsNotConnected(let peripheralID):
                return "The peripheral \(peripheralID.uuidString) is not connected"
            case .serviceNotFound(let serviceID, let peripheralID):
                return "A service \(serviceID) is not found in the peripheral \(peripheralID) (make sure it has been discovered)"
            case .characteristicNotFound(let qualifiedCharacteristic):
                return "A characteristic \(qualifiedCharacteristic.id) is not found in the service \(qualifiedCharacteristic.serviceID) of the peripheral \(qualifiedCharacteristic.peripheralID) (make sure it has been discovered)"
            case .notificationsNotSupported(let qualifiedCharacteristic):
                return "The characteristic \(qualifiedCharacteristic.id) of the service \(qualifiedCharacteristic.serviceID) of the peripheral \(qualifiedCharacteristic.peripheralID) does not support either notifications or indications"
            case .notReadable(let qualifiedCharacteristic):
                return "The characteristic \(qualifiedCharacteristic.id) of the service \(qualifiedCharacteristic.serviceID) of the peripheral \(qualifiedCharacteristic.peripheralID) is not readable"
            case .notWritable(let qualifiedCharacteristic):
                return "The characteristic \(qualifiedCharacteristic.id) of the service \(qualifiedCharacteristic.serviceID) of the peripheral \(qualifiedCharacteristic.peripheralID) is not writable"
            }
        }
    }
}
