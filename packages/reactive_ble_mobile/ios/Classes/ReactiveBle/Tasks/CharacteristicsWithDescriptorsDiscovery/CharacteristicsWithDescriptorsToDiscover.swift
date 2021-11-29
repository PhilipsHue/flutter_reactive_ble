import CoreBluetooth

enum CharacteristicsWithDescriptorsToDiscover: Equatable {

    case some([CBCharacteristic])

    var isEmpty: Bool {
        switch self {
        case .some(let characteristicsWithDescriptorsToDiscover):
            return characteristicsWithDescriptorsToDiscover.isEmpty
        }
    }

    var characteristics: [CBCharacteristic] {
        switch self {
        case .some(let characteristicsWithDescriptorsToDiscover):
            return Array(characteristicsWithDescriptorsToDiscover)
        }
    }
}

