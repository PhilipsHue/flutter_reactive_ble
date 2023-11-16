import CoreBluetooth

final class PeripheralDelegate: NSObject, CBPeripheralDelegate {
    typealias ServicesModifyHandler = (CBPeripheral, [CBService]) -> Void
    typealias ServicesDiscoveryHandler = (CBPeripheral, Error?) -> Void
    typealias CharacteristicsDiscoverHandler = (CBService, Error?) -> Void
    typealias CharacteristicNotificationStateUpdateHandler = (CBCharacteristic, Error?) -> Void
    typealias CharacteristicValueUpdateHandler = (CBCharacteristic, Error?) -> Void
    typealias CharacteristicValueWriteHandler = (CBCharacteristic, Error?) -> Void
    typealias PeripheralIsReadyHandler = (CBPeripheral, Error?) -> Void

    private let onServicesModify: ServicesModifyHandler
    private let onServicesDiscovery: ServicesDiscoveryHandler
    private let onCharacteristicsDiscovery: CharacteristicsDiscoverHandler
    private let onCharacteristicNotificationStateUpdate: CharacteristicNotificationStateUpdateHandler
    private let onCharacteristicValueUpdate: CharacteristicValueUpdateHandler
    private let onCharacteristicValueWrite: CharacteristicValueWriteHandler
    private let onPeripheralIsReady: PeripheralIsReadyHandler

    init(
        onServicesModify: @escaping ServicesModifyHandler,
        onServicesDiscovery: @escaping ServicesDiscoveryHandler,
        onCharacteristicsDiscovery: @escaping CharacteristicsDiscoverHandler,
        onCharacteristicNotificationStateUpdate: @escaping CharacteristicNotificationStateUpdateHandler,
        onCharacteristicValueUpdate: @escaping CharacteristicValueUpdateHandler,
        onCharacteristicValueWrite: @escaping CharacteristicValueWriteHandler,
        onPeripheralIsReady: @escaping PeripheralIsReadyHandler
    ) {
        self.onServicesModify = onServicesModify
        self.onServicesDiscovery = onServicesDiscovery
        self.onCharacteristicsDiscovery = onCharacteristicsDiscovery
        self.onCharacteristicNotificationStateUpdate = onCharacteristicNotificationStateUpdate
        self.onCharacteristicValueUpdate = onCharacteristicValueUpdate
        self.onCharacteristicValueWrite = onCharacteristicValueWrite
        self.onPeripheralIsReady = onPeripheralIsReady
    }

    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        onServicesModify(peripheral, invalidatedServices)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        onServicesDiscovery(peripheral, error)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        onCharacteristicsDiscovery(service, error)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        onCharacteristicNotificationStateUpdate(characteristic, error)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        onCharacteristicValueUpdate(characteristic, error)
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        onCharacteristicValueWrite(characteristic, error)
    }

    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        onPeripheralIsReady(peripheral, nil)
    }
}
