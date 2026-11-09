import CoreBluetooth

struct ReadRssiTaskController: PeripheralTaskController {
    typealias TaskSpec = ReadRssiTaskSpec
    
    private let task: SubjectTask
    
    init(_ task: SubjectTask) {
        self.task = task
    }
    
    func start(peripheral: CBPeripheral) -> SubjectTask {
        // error if not connected
        guard peripheral.state == .connected
        else {
            return task.with(
                state: task.state.finished(
                    .failure(PluginError.internalInconcictency(details: nil))
                )
            )
        }
        
        peripheral.readRSSI()
        
        return task.with(state: task.state.processing(.readingRssi))
    }
    
    func cancel(error: Error) -> SubjectTask {
        return task
            .with(state: task.state.finished(.failure(error)))
    }
    
    func handleReadRssi(rssi: Int, error: Error?) -> SubjectTask {
        if let error = error {
            return task
                .with(state: task.state.finished(.failure(error)))
        } else {
            return task
                .with(state: task.state.finished(.success(rssi)))
        }
    }
}
