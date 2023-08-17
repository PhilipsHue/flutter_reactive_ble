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
            let characteristicIndex = service.characteristics?.filter({ c in c.uuid == characteristic.uuid }).index(of: characteristic)
        else {
            throw Failure.characteristicNotFound
        }
        
        guard
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
