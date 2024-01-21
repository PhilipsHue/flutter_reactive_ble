import enum CoreBluetooth.CBPeripheralState

func encode(_ connectionState: CBPeripheralState) -> Int32 {
    switch connectionState {
    case .disconnected:
        return 3
    case .connecting:
        return 0
    case .connected:
        return 1
    case .disconnecting:
        return 2
    }
}
