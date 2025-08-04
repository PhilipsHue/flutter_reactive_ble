import CoreBluetooth

struct ServicesWithCharacteristicsDiscoveryTaskSpec: PeripheralTaskSpec {

    typealias Key = PeripheralID

    struct Params {

        let servicesWithCharacteristicsToDiscover: ServicesWithCharacteristicsToDiscover
    }

    enum Stage {

        case discoveringServices
        case discoveringCharacteristics(servicesLeft: Int, errors: [Error])
    }

    typealias Result = [Error]

    static let tag = "DISCOVER S&C"

    static func isMember(_ key: Key, of group: PeripheralID) -> Bool {
        return key == group
    }
}
