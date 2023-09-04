import CoreBluetooth

struct CharacteristicWriteTaskController: PeripheralTaskController {

    typealias TaskSpec = CharacteristicWriteTaskSpec

    private let task: SubjectTask

    init(_ task: SubjectTask) {
        self.task = task
    }

    func start(peripheral: CBPeripheral) -> SubjectTask {
        guard
            peripheral.state == .connected,
            let service = peripheral.services?.filter({ $0.uuid == task.key.serviceID })[Int(task.key.serviceInstanceID) ?? 0],
            let characteristic = service.characteristics?.filter({ $0.uuid == task.key.id })[Int(task.key.instanceID) ?? 0],
            characteristic.properties.contains(.write)
        else {
            return task.with(state: task.state.finished(PluginError.internalInconcictency(details: nil)))
        }

        peripheral.writeValue(task.params.value, for: characteristic, type: .withResponse)

        return task.with(state: task.state.processing(.writing))
    }

    func cancel(error: Error) -> SubjectTask {
        return task.with(state: task.state.finished(error))
    }

    func handleWrite(error: Error?) -> SubjectTask {
        return task.with(state: task.state.finished(error))
    }
}
