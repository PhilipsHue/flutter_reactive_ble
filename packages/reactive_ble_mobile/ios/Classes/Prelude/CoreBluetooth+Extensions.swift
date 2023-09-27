#if compiler(<5.5)
import class CoreBluetooth.CBCharacteristic
import class CoreBluetooth.CBService
import class CoreBluetooth.CBPeripheral

// Extensions below are supposed to backport API breaking changes
// in CoreBluetooth framework which Apple introduced with Xcode 13:
//
// ```
// + weak var peripheral: CBPeripheral? { get }
// - unowned(unsafe) var peripheral: CBPeripheral { get }
// ```
//
// Thus this code shadows original property declarations in CoreBluetooth
// and changes their semantics from `unsafe non-optional` to `weak optional`
// to mimic Xcode 13 behaviour.
//
// - Note: This code compiles only when using Xcode 12 and below.
// - SeeAlso: https://forums.swift.org/t/is-unowned-unsafe-t-weak-t-a-breaking-change/49917

extension CBCharacteristic {
    @nonobjc
    weak var service: CBService? {
        return value(forKey: #function) as? CBService
    }
}

extension CBService {
    @nonobjc
    weak var peripheral: CBPeripheral? {
        return value(forKey: #function) as? CBPeripheral
    }
}
#endif
