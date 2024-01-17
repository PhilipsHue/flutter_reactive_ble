import class CoreBluetooth.CBUUID
import class CoreBluetooth.CBCharacteristic
import class CoreBluetooth.CBService

struct CharacteristicInstance: Equatable {

    let id: CharacteristicID
    let instanceID: CharacteristicInstanceID
    let serviceID: ServiceID
    let serviceInstanceID: ServiceInstanceID
    let peripheralID: PeripheralID
}

extension CharacteristicInstance {

    init(_ characteristic: CBCharacteristic) throws {
        guard let service = characteristic.service
        else {
            throw Failure.serviceNotFound
        }

        guard let peripheral = service.peripheral
        else {
            throw Failure.peripheralNotFound
        }

        guard
            // Since CBCharacteristic has no field that identifies a specific instance of a characteristic (among those with the same id),
            // the index among the characteristics with the same uuid within a service is used as identification. This assumes characteristics
            // aren't reordered when new charcteristics are discovered later.
            let characteristicIndex = service.characteristics?.filter({ c in c.uuid == characteristic.uuid }).index(of: characteristic)
        else {
            throw Failure.characteristicNotFound
        }

        guard
            // Since CBService has no field that identifies a specific instance of a service (among those with the same id),
            // the index among the services with the same uuid is used as identification. This assumes services are not reordered when
            // new services are discovered later.
            let serviceIndex = peripheral.services?.filter({ s in s.uuid == service.uuid }).index(of: service)
        else {
            throw Failure.serviceNotFound
        }

        self.init(
            id: characteristic.uuid,
            instanceID: "\(characteristicIndex)",
            serviceID: service.uuid,
            serviceInstanceID: "\(serviceIndex)",
            peripheralID: peripheral.identifier
        )
    }
    
    private enum Failure: Error, CustomStringConvertible {

        case serviceNotFound
        case peripheralNotFound
        case characteristicNotFound

        var description: String {
            switch self {
            case .serviceNotFound:
                return "Service not found"
            case .peripheralNotFound:
                return "Peripheral not found"
            case .characteristicNotFound:
                return "Characteristic not found"
            }
        }
    }
}

struct CharacteristicInstanceIDFactory {
    
    func make(from message: CharacteristicAddress) -> CharacteristicInstance? {
        guard
            message.hasCharacteristicUuid,
            message.hasServiceUuid,
            let peripheralID = UUID(uuidString: message.deviceID)
        else { return nil }

        let characteristicID = CBUUID(data: message.characteristicUuid.data)
        let serviceID = CBUUID(data: message.serviceUuid.data)

        return CharacteristicInstance(
            id: characteristicID,
            instanceID: message.characteristicInstanceID,
            serviceID: serviceID,
            serviceInstanceID: message.serviceInstanceID,
            peripheralID: peripheralID
        )
    }
}

public extension CBCharacteristic {
    var instanceId: Int? {
        return service?.characteristics?.filter({ c in c.uuid == uuid }).index(of: self)
    }
}

public extension CBService {
    var instanceId: Int? {
        return peripheral?.services?.filter({ s in s.uuid == uuid }).index(of: self)
    }
}
