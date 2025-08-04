enum ServicesWithCharacteristicsToDiscover: Equatable {

    case all
    case some([ServiceID: CharacteristicsToDiscover])

    var isEmpty: Bool {
        switch self {
        case .all:
            return false
        case .some(let servicesWithCharacteristicsToDiscover):
            return servicesWithCharacteristicsToDiscover.isEmpty
        }
    }

    var services: [ServiceID]? {
        switch self {
        case .all:
            return nil
        case .some(let servicesWithCharacteristicsToDiscover):
            return Array(servicesWithCharacteristicsToDiscover.keys)
        }
    }
}

enum CharacteristicsToDiscover: Equatable {

    case all
    case some([CharacteristicID])

    var characteristics: [CharacteristicID]? {
        switch self {
        case .all:
            return nil
        case .some(let characteristicsToDiscover):
            return characteristicsToDiscover
        }
    }
}
