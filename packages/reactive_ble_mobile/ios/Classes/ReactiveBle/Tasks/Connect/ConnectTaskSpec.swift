struct ConnectTaskSpec: PeripheralTaskSpec {

    typealias Key = PeripheralID
    
    struct Params {}

    enum Stage {

        case connecting
    }

    typealias Result = ConnectionChange

    static let tag = "CONNECT"

    static func isMember(_ key: Key, of group: PeripheralID) -> Bool {
        return key == group
    }
}
