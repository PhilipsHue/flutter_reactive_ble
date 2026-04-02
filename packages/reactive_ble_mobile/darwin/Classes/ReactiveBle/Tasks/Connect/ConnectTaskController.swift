import CoreBluetooth

struct ConnectTaskController: PeripheralTaskController {

    typealias TaskSpec = ConnectTaskSpec

    private let task: SubjectTask

    init(_ task: SubjectTask) {
        self.task = task
    }

    func connect(centralManager: CBCentralManager, peripheral: CBPeripheral) -> SubjectTask {
        guard case .pending = task.state else {
            return task.with(state: task.state.finished(.failedToConnect(
                NSError(domain: "ConnectTaskController", code: -1, 
                       userInfo: [NSLocalizedDescriptionKey: "Invalid state for connect operation"]))))
        }

        centralManager.connect(peripheral)
        return task.with(state: task.state.processing(.connecting))
    }

    func handleConnectionChange(_ connectionChange: ConnectionChange) -> SubjectTask {
        guard case .processing(since: _, .connecting) = task.state else {
            return task.with(state: task.state.finished(.failedToConnect(
                NSError(domain: "ConnectTaskController", code: -2,
                       userInfo: [NSLocalizedDescriptionKey: "Invalid state for connection change"]))))
        }

        return task.with(state: task.state.finished(connectionChange))
    }

    func cancel(centralManager: CBCentralManager, peripheral: CBPeripheral, error: Error?) -> SubjectTask {
        switch task.state {
        case .pending:
            return task.with(state: task.state.finished(.failedToConnect(error)))
        case .processing(since: _, .connecting):
            centralManager.cancelPeripheralConnection(peripheral)
            return task.with(state: task.state.finished(.failedToConnect(error)))
        case .finished:
            return task.with(state: task.state.finished(.failedToConnect(
                NSError(domain: "ConnectTaskController", code: -3,
                       userInfo: [NSLocalizedDescriptionKey: "Cannot cancel already finished task"]))))
        }
    }
}
