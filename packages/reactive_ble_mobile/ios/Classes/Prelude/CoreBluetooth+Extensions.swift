import class CoreBluetooth.CBCharacteristic
import class CoreBluetooth.CBService
import class CoreBluetooth.CBPeripheral

#if compiler(<5.5)
extension CBCharacteristic {
    @nonobjc
    var service: CBService? {
        return value(forKey: #function) as? CBService
    }
}

extension CBService {
    @nonobjc
    var peripheral: CBPeripheral? {
        return value(forKey: #function) as? CBPeripheral
    }
}
#endif
