import enum CoreBluetooth.CBManagerState

func encode(_ centralState: CBManagerState) -> Int32 {
    switch (centralState) {
    case .unknown, .resetting:
        return 0
    case .unsupported:
        return 1
    case .unauthorized:
        return 2
    case .poweredOff:
        return 3
    case .poweredOn:
        return 5
    }
}
