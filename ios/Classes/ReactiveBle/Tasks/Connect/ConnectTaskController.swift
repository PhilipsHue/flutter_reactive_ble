import CoreBluetooth

struct ConnectTaskController: PeripheralTaskController {

    typealias TaskSpec = ConnectTaskSpec

    private let task: PTask

    init(_ task: PTask) {
        self.task = task
    }

    func connect(centralManager: CBCentralManager, peripheral: CBPeripheral) -> PTask {
        guard case .pending = task.state
        else {
            assert(false)
            return task
        }

        centralManager.connect(peripheral)

        return task.with(state: task.state.processing(.connecting))
    }

    func handleConnectionChange(_ connectionChange: ConnectionChange) -> PTask {
        guard case .processing(since: _, .connecting) = task.state
        else {
            assert(false)
            return task
        }

        return task.with(state: task.state.finished(connectionChange))
    }

    func cancel(centralManager: CBCentralManager, peripheral: CBPeripheral, error: Error?) -> PTask {
        switch task.state {
        case .pending:
            return task.with(state: task.state.finished(.failedToConnect(error)))
        case .processing(since: _, .connecting):
            centralManager.cancelPeripheralConnection(peripheral)
            return task.with(state: task.state.finished(.failedToConnect(error)))
        case .finished(in: _, _):
            assert(false)
            return task
        }
    }
}
