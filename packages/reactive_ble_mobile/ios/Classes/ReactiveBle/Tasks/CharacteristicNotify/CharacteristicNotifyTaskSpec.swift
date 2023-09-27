struct CharacteristicNotifyTaskSpec: PeripheralTaskSpec {

    typealias Key = QualifiedCharacteristic

    struct Params {

        let state: OnOff
    }

    enum Stage {

        case applying
    }

    typealias Result = Error?

    static let tag = "NOTIFY"

    static func isMember(_ key: Key, of group: PeripheralID) -> Bool {
        return key.peripheralID == group
    }
}
