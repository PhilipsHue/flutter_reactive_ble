import CoreBluetooth

struct CharacteristicNotifyTaskController: PeripheralTaskController {

    typealias TaskSpec = CharacteristicNotifyTaskSpec

    private let task: PTask

    init(_ task: PTask) {
        self.task = task
    }

    func start(characteristic: CBCharacteristic) -> PTask {
        characteristic.service!.peripheral!.setNotifyValue(task.params.state.isOn, for: characteristic)
        return task.with(state: task.state.processing(.applying))
    }

    func cancel(error: Error) -> PTask {
        return task.with(state: task.state.finished(error))
    }

    func complete(error: Error?) -> PTask {
        return task.with(state: task.state.finished(error))
    }
}
