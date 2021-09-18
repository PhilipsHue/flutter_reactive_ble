import CoreBluetooth

struct CharacteristicNotifyTaskController: PeripheralTaskController {

    typealias TaskSpec = CharacteristicNotifyTaskSpec

    private let task: SubjectTask

    init(_ task: SubjectTask) {
        self.task = task
    }

    func start(characteristic: CBCharacteristic) -> SubjectTask {
        characteristic.service.peripheral.setNotifyValue(task.params.state.isOn, for: characteristic)
        return task.with(state: task.state.processing(.applying))
    }

    func cancel(error: Error) -> SubjectTask {
        return task.with(state: task.state.finished(error))
    }

    func complete(error: Error?) -> SubjectTask {
        return task.with(state: task.state.finished(error))
    }
}
