enum OnOff {

    case on
    case off

    var isOn: Bool {
        switch self {
        case .on:
            return true
        case .off:
            return false
        }
    }
}
