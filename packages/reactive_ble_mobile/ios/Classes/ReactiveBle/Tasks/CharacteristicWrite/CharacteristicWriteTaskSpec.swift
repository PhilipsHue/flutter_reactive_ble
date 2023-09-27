struct CharacteristicWriteTaskSpec: PeripheralTaskSpec {

    typealias Key = QualifiedCharacteristic

    struct Params {

        let value: Data
    }

    enum Stage {

        case writing
    }

    typealias Result = Error?

    static let tag = "WRITE"

    static func isMember(_ key: Key, of group: PeripheralID) -> Bool {
        return key.peripheralID == group
    }
}
