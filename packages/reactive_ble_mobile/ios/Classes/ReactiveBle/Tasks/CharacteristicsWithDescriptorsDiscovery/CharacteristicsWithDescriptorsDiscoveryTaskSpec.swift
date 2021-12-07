import CoreBluetooth

struct CharacteristicsWithDescriptorsDiscoveryTaskSpec: PeripheralTaskSpec {

    typealias Key = CharacteristicID

    struct Params {

        let characteristicsWithDescriptorsToDiscover: CharacteristicsWithDescriptorsToDiscover
    }

    enum Stage {

        case discoveringDescriptors(characteristicsLeft: Int, errors: [Error])
    }

    typealias Result = [Error]

    static let tag = "DISCOVER D"

    static func isMember(_ key: Key, of group: CharacteristicID) -> Bool {
        return key == group
    }
}
