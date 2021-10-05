import enum CoreBluetooth.CBCentralManagerState

func encode(_ centralState: CBCentralManagerState) -> Int32 {
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
