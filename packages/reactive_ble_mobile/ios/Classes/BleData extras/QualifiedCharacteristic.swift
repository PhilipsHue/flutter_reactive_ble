import class CoreBluetooth.CBUUID
import class CoreBluetooth.CBCharacteristic

struct QualifiedCharacteristic: Equatable {

    let id: CharacteristicID
    let serviceID: ServiceID
    let peripheralID: PeripheralID
}

extension QualifiedCharacteristic {

    init(_ characteristic: CBCharacteristic) {
        self.init(
            id: characteristic.uuid,
            serviceID: characteristic.service?.uuid ?? ServiceID(),
            peripheralID: characteristic.service?.peripheral?.identifier ?? PeripheralID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        )
    }
}

struct QualifiedCharacteristicIDFactory {

    func make(from message: CharacteristicAddress) -> QualifiedCharacteristic? {
        guard
            message.hasCharacteristicUuid,
            message.hasServiceUuid,
            let peripheralID = UUID(uuidString: message.deviceID)
        else { return nil }

        let characteristicID = CBUUID(data: message.characteristicUuid.data)
        let serviceID = CBUUID(data: message.serviceUuid.data)

        return QualifiedCharacteristic(
            id: characteristicID,
            serviceID: serviceID,
            peripheralID: peripheralID
        )
    }
}
