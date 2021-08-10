import CoreBluetooth

struct CharacteristicNotifyTaskController: PeripheralTaskController {

    typealias TaskSpec = CharacteristicNotifyTaskSpec

    private let task: Task

    init(_ task: Task) {
        self.task = task
    }

    func start(characteristic: CBCharacteristic) -> Task {
        characteristic.service.peripheral.setNotifyValue(task.params.state.isOn, for: characteristic)
        return task.with(state: task.state.processing(.applying))
    }

    func cancel(error: Error) -> Task {
        return task.with(state: task.state.finished(error))
    }

    func complete(error: Error?) -> Task {
        return task.with(state: task.state.finished(error))
    }
}
