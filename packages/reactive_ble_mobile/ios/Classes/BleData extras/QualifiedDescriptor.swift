import class CoreBluetooth.CBUUID
import class CoreBluetooth.CBDescriptor
import CoreBluetooth

struct QualifiedDescriptor: Equatable {

    let id: DescriptorID
    let characteristicID: CharacteristicID
    let serviceID: ServiceID
    let peripheralID: PeripheralID
}

extension QualifiedDescriptor {

    init(_ descriptor: CBDescriptor) {
        self.init(
            id: descriptor.uuid,
            characteristicID: descriptor.characteristic?.uuid ?? CharacteristicID(),
            serviceID: descriptor.characteristic?.service?.uuid ?? ServiceID(),
            peripheralID: descriptor.characteristic?.service?.peripheral?.identifier ?? PeripheralID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        )
    }
}

struct QualifiedDescriptorIDFactory {

    func make(from message: DescriptorAddress) -> QualifiedDescriptor? {
        guard
            message.hasCharacteristicUuid,
            message.hasDescriptorUuid,
            message.hasServiceUuid,
            let peripheralID = UUID(uuidString: message.deviceID)
        else { return nil }

        let descriptorID = CBUUID(data: message.descriptorUuid.data)
        let characteristicID = CBUUID(data: message.characteristicUuid.data)
        let serviceID = CBUUID(data: message.serviceUuid.data)

        return QualifiedDescriptor(
            id: descriptorID,
            characteristicID: characteristicID,
            serviceID: serviceID,
            peripheralID: peripheralID
        )
    }
}
