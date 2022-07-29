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
    typealias CharacteristicSubscribedByCentralHandler = (Central, CBCentral, CBCharacteristic) -> Void
    typealias SubChangeHandler = (Central, CBCentral, CBCharacteristic) -> Void

    private let onServicesWithCharacteristicsInitialDiscovery: ServicesWithCharacteristicsDiscoveryHandler

    private var peripheralDelegate: PeripheralDelegate!
    private var centralManagerDelegate: CentralManagerDelegate!
    private var centralManager: CBCentralManager!

    private var peripheralManager: CBPeripheralManager!
    private var peripheralManagerDelegate: PeripheralManagerDelegate!

    private(set) var isScanning = false
    private(set) var activePeripherals = [PeripheralID: CBPeripheral]()
    private(set) var connectRegistry = PeripheralTaskRegistry<ConnectTaskController>()
    private let servicesWithCharacteristicsDiscoveryRegistry = PeripheralTaskRegistry<ServicesWithCharacteristicsDiscoveryTaskController>()
    private let characteristicNotifyRegistry = PeripheralTaskRegistry<CharacteristicNotifyTaskController>()
    private let characteristicWriteRegistry = PeripheralTaskRegistry<CharacteristicWriteTaskController>()

    init(
        onSubChange: @escaping SubChangeHandler,
        onStateChange: @escaping StateChangeHandler,
        onDiscovery: @escaping DiscoveryHandler,
        onConnectionChange: @escaping ConnectionChangeHandler,
        onServicesWithCharacteristicsInitialDiscovery: @escaping ServicesWithCharacteristicsDiscoveryHandler,
        onCharacteristicValueUpdate: @escaping CharacteristicValueUpdateHandler,
        onCharacteristicSubscribedByCentral: @escaping CharacteristicSubscribedByCentralHandler
    ) {
        self.onServicesWithCharacteristicsInitialDiscovery = onServicesWithCharacteristicsInitialDiscovery
        self.peripheralManagerDelegate = PeripheralManagerDelegate(
            onSubChange: papply(weak: self) { central, connectedCentral, characteristic in
                print("characteristic: ", characteristic)
                onSubChange(central, connectedCentral, characteristic)
        })
        self.centralManagerDelegate = CentralManagerDelegate(
            onStateChange: papply(weak: self) { central, state in
                if state != .poweredOn {
                    central.activePeripherals.forEach { _, peripheral in
                        let error = Failure.notPoweredOn(actualState: state)
                        central.eject(peripheral, error: error)
                        onConnectionChange(central, peripheral, .disconnected(error))
                    }
                }
                print("ConnectionState: ", state)
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
                print("onConnectionChange2: ", change)
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
        self.peripheralManager = CBPeripheralManager(
            delegate: peripheralManagerDelegate,
            queue: nil)
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

    func startAdvertising(){
        print("startAdvertising")
        addExampleGattService()
        
        let SERVICE_UUID: String = "61808880-B7B3-11E4-B3A4-0002A5D5C51B"//: UUID = UUID.parse("61808880-B7B3-11E4-B3A4-0002A5D5C51B")
        //CBAdvertisementDataServiceUUIDsKey: SERVICE_UUID,
        
        peripheralManager.startAdvertising([CBAdvertisementDataLocalNameKey: "Truma Ben",
                                            //CBAdvertisementDataIsConnectable: true])
                                            CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: SERVICE_UUID)]])
    }
    
    func stopAdvertising(){
        print("stopAdvertising")
        peripheralManager.stopAdvertising()
        peripheralManager.removeAllServices()
    }

    func addExampleGattService() {
        //let CccdUID: String = "00002902-0000-1000-8000-00805f9b34fb"

        let SrvUUID1: String = "d0611e78-bbb4-4591-a5f8-487910ae4366"
        let SrvUUID2: String = "ad0badb1-5b99-43cd-917a-a77bc549e3cc"
        let SrvUUID3: String = "73a58d00-c5a1-4f8e-8f55-1def871ddc81"

        let CharUUID1: String = "8667556c-9a37-4c91-84ed-54ee27d90049"
        let CharUUID2: String = "af0badb1-5b99-43cd-917a-a77bc549e3cc"
        let CharUUID3: String = "73a58d01-c5a1-4f8e-8f55-1def871ddc81"

        let UartSrvUUID    : String = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
        let UartCharRxUUID : String = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
        let UartCharTxUUID : String = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"

        let uartproperties: CBCharacteristicProperties = [.notify, .read, .write]
        let uartpermissions: CBAttributePermissions = [.readable, .writeable]

        var UartCharRxProperties = CBCharacteristicProperties.read;
        UartCharRxProperties.formUnion(CBCharacteristicProperties.notify)
        
        var UartCharTxProperties = CBCharacteristicProperties.write;//notify;
        UartCharTxProperties.formUnion(CBCharacteristicProperties.writeWithoutResponse)
        
        var Properties1 = CBCharacteristicProperties.write
        Properties1.formUnion(CBCharacteristicProperties.notify)
        
        var Properties2 = CBCharacteristicProperties.write;
        Properties2.formUnion(CBCharacteristicProperties.notify)
        
        var Properties3 = CBCharacteristicProperties.read;
        Properties3.formUnion(CBCharacteristicProperties.notify)

        /*
        let CCCD1: CBMutableDescriptor = CBMutableDescriptor(
            type: CBUUID(string: CccdUID),
            value: 0)

        let CCCD2: CBMutableDescriptor = CBMutableDescriptor(
            type: CBUUID(string: CccdUID),
            value: 0)

        let CCCD3: CBMutableDescriptor = CBMutableDescriptor(
            type: CBUUID(string: CccdUID),
            value: 0)*/
        
        let Characteristic1: CBMutableCharacteristic = CBMutableCharacteristic(
            type: CBUUID(string: CharUUID1),
            properties: Properties1,
            value: nil,
            permissions: CBAttributePermissions.writeable)

        let Characteristic2: CBMutableCharacteristic = CBMutableCharacteristic(
            type: CBUUID(string: CharUUID2),
            properties: Properties2,
            value: nil,
            permissions: CBAttributePermissions.writeable)

        let Characteristic3: CBMutableCharacteristic = CBMutableCharacteristic(
            type: CBUUID(string: CharUUID3),
            properties: Properties3,
            value: nil,
            permissions: CBAttributePermissions.readable)
        
        let UartCharRx: CBMutableCharacteristic = CBMutableCharacteristic(
                    type: CBUUID(string: UartCharRxUUID),
                    properties: UartCharRxProperties,//UartCharRxProperties,
                    value: nil,
                    permissions: uartpermissions)//CBAttributePermissions.writeable)

        let UartCharTx: CBMutableCharacteristic = CBMutableCharacteristic(
                    type: CBUUID(string: UartCharTxUUID),
                    properties: UartCharTxProperties,//UartCharTxProperties,
                    value: nil,
                    permissions: uartpermissions)//CBAttributePermissions.writeable)//readable)

        
        //CBUUID.init(CBUUIDCharacteristicUserDescriptionString)
        
        //Characteristic1.descriptors = [CCCD1];
        //Characteristic2.descriptors = [CCCD2];
        //Characteristic3.descriptors = [CCCD3];
        
        let service1 = CBMutableService(
            type: CBUUID(string: SrvUUID1),
             primary: true)

        let service2 = CBMutableService(
            type: CBUUID(string: SrvUUID2),
            primary: true)

        let service3 = CBMutableService(
            type: CBUUID(string: SrvUUID3),
            primary: true)
        
        let uartService = CBMutableService(
            type: CBUUID(string: UartSrvUUID),
            primary: true)
        
        service1.characteristics = [Characteristic1]
        service2.characteristics = [Characteristic2]
        service3.characteristics = [Characteristic3]
        uartService.characteristics = [UartCharRx, UartCharTx]

        
        peripheralManager.add(service1)
        peripheralManager.add(service2)
        peripheralManager.add(service3)
        peripheralManager.add(uartService)
    }

    func startGattServer() {
        // TODO Move from addExampleGattService to startGattServer
    }

    func stopGattServer() {
        // clear and close gatt server after advertising stopped
        peripheralManager.removeAllServices()
    }

    func addGattService() {
        // TODO Move from addExampleGattService to addGattService
        // Note: Only add one Service add the time and wait for the onServiceAdded event.
        //       After receiving onServiceAdded add next service

        /*
        CBUUID *serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
        CBMutableService *service;
        service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];

        peripheralManager.addService(service)
        */
    }

    func addGattCharacteristic() {
        // TODO Move from addExampleGattService to addGattCharacteristic
        /*
        let characteristicUUID = CBUUID(string: kCharacteristicUUID)
        let properties: CBCharacteristicProperties = [.Notify, .Read, .Write]
        let permissions: CBAttributePermissions = [.Readable, .Writeable]
        let characteristic = CBMutableCharacteristic(type: characteristicUUID, properties: properties, value: nil, permissions: permissions)

        service.characteristics = [characteristic1, characteristic2]
         */
    }

    func connect(to peripheralID: PeripheralID, discover servicesWithCharacteristicsToDiscover: ServicesWithCharacteristicsToDiscover, timeout: TimeInterval?) throws {
        print("connect")
        let peripheral = try resolve(known: peripheralID)

        peripheral.delegate = peripheralDelegate
        activePeripherals[peripheral.identifier] = peripheral

        /*
        if(peripheral.state == .connected){
            onConnectionChange(central, peripheral, peripheral.state)
        }
        */

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
                print("connectionChange: ", connectionChange)
            }
        )

        connectRegistry.updateTask(
            key: peripheralID,
            action: { $0.connect(centralManager: centralManager, peripheral: peripheral) }
        )
    }

    func disconnect(from peripheralID: PeripheralID) {
        print("disconnect")
        guard let peripheral = try? resolve(known: peripheralID)
        else { return }

        centralManager.cancelPeripheralConnection(peripheral)
    }

    func disconnectAll() {
        print("disconnect all")
        activePeripherals
            .values
            .forEach(centralManager.cancelPeripheralConnection)
    }

    func discoverServicesWithCharacteristics(
        for peripheralID: PeripheralID,
        discover servicesWithCharacteristicsToDiscover: ServicesWithCharacteristicsToDiscover,
        completion: @escaping ServicesWithCharacteristicsDiscoveryHandler
    ) throws -> Void {
        print("discoverServicesWithCharacteristics")
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
        print("discoverServicesWithCharacteristics")
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
        print("eject")
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
        print("resolve known PeripheralID")
        guard let peripheral = centralManager.retrievePeripherals(withIdentifiers: [peripheralID]).first
        else { throw Failure.peripheralIsUnknown(peripheralID) }

        return peripheral
    }

    private func resolve(connected peripheralID: PeripheralID) throws -> CBPeripheral {
        print("resolve connected PeripheralID")
        guard let peripheral = activePeripherals[peripheralID]
        else {
            print("peripheral is unknown")
            throw Failure.peripheralIsUnknown(peripheralID)
        }

        guard peripheral.state == .connected
        else {
            print("peripheral is not connected")
            throw Failure.peripheralIsNotConnected(peripheralID)
        }

        return peripheral
    }

    private func resolve(characteristic qualifiedCharacteristic: QualifiedCharacteristic) throws -> CBCharacteristic {
        print("resolve qualifiedCharacteristic")
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
