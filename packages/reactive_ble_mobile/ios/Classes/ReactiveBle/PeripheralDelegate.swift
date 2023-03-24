import CoreBluetooth

final class PeripheralDelegate: NSObject, CBPeripheralDelegate {

    typealias ServicesDiscoveryHandler = (CBPeripheral, Error?) -> Void
    typealias CharacteristicsDiscoverHandler = (CBService, Error?) -> Void
    typealias CharacteristicNotificationStateUpdateHandler = (CBCharacteristic, Error?) -> Void
    typealias CharacteristicValueUpdateHandler = (CBCharacteristic, Error?) -> Void
    typealias CharacteristicValueWriteHandler = (CBCharacteristic, Error?) -> Void

    private let onServicesDiscovery: ServicesDiscoveryHandler
    private let onCharacteristicsDiscovery: CharacteristicsDiscoverHandler
    private let onCharacteristicNotificationStateUpdate: CharacteristicNotificationStateUpdateHandler
    private let onCharacteristicValueUpdate: CharacteristicValueUpdateHandler
    private let onCharacteristicValueWrite: CharacteristicValueWriteHandler

    init(
        onServicesDiscovery: @escaping ServicesDiscoveryHandler,
        onCharacteristicsDiscovery: @escaping CharacteristicsDiscoverHandler,
        onCharacteristicNotificationStateUpdate: @escaping CharacteristicNotificationStateUpdateHandler,
        onCharacteristicValueUpdate: @escaping CharacteristicValueUpdateHandler,
        onCharacteristicValueWrite: @escaping CharacteristicValueWriteHandler
    ) {
        self.onServicesDiscovery = onServicesDiscovery
        self.onCharacteristicsDiscovery = onCharacteristicsDiscovery
        self.onCharacteristicNotificationStateUpdate = onCharacteristicNotificationStateUpdate
        self.onCharacteristicValueUpdate = onCharacteristicValueUpdate
        self.onCharacteristicValueWrite = onCharacteristicValueWrite
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("peripheral didDiscoverServices")
        onServicesDiscovery(peripheral, error)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("peripheral didDiscoverCharacteristicsFor")
        //print("=>", service)
        onCharacteristicsDiscovery(service, error)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("peripheral didUpdateNotificationStateFor")
        onCharacteristicNotificationStateUpdate(characteristic, error)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("peripheral didUpdateValueFor")
        onCharacteristicValueUpdate(characteristic, error)
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("peripheral didWriteValueFor")
        onCharacteristicValueWrite(characteristic, error)
    }
}
