import CoreBluetooth

enum ConnectionChange {
    case connected
    case failedToConnect(Error?)
    case disconnected(Error?)
}

final class CentralManagerDelegate: NSObject, CBCentralManagerDelegate {

    typealias StateChangeHandler = (CBManagerState) -> Void
    typealias DiscoveryHandler = (CBPeripheral, AdvertisementData, RSSI) -> Void
    typealias ConnectionChangeHandler = (CBPeripheral, ConnectionChange) -> Void

    private let onStateChange: StateChangeHandler
    private let onDiscovery: DiscoveryHandler
    private let onConnectionChange: ConnectionChangeHandler

    init(
        onStateChange: @escaping StateChangeHandler,
        onDiscovery: @escaping DiscoveryHandler,
        onConnectionChange: @escaping ConnectionChangeHandler
    ) {
        self.onStateChange = onStateChange
        self.onDiscovery = onDiscovery
        self.onConnectionChange = onConnectionChange
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        onStateChange(central.state)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        onDiscovery(peripheral, advertisementData, rssi.intValue)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        onConnectionChange(peripheral, .connected)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        onConnectionChange(peripheral, .failedToConnect(error))
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        onConnectionChange(peripheral, .disconnected(error))
    }
}
