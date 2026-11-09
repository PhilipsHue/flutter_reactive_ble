struct ReadRssiTaskSpec: PeripheralTaskSpec {
    typealias Key = PeripheralID
    
    struct Params {}
    
    enum Stage {
        case readingRssi
    }
    
    typealias Result = Failable<Int>
    
    static let tag = "READ RSSI"
    
    static func isMember(_ key: Key, of group: PeripheralID) -> Bool {
        return key == group
    }
}
