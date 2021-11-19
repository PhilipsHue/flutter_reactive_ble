import CoreBluetooth

struct CharacteristicNotifyTaskController: PeripheralTaskController {

    typealias TaskSpec = CharacteristicNotifyTaskSpec

    private let task: SubjectTask

    init(_ task: SubjectTask) {
        self.task = task
    }

    func start(characteristic: CBCharacteristic) -> SubjectTask {
        guard let peripheral = characteristic.service?.peripheral
        else { return task.with(state: task.state.finished(CharacteristicNotifyError.unExpected)) }
        
        peripheral.setNotifyValue(task.params.state.isOn, for: characteristic)
        return task.with(state: task.state.processing(.applying))
    }

    func cancel(error: Error) -> SubjectTask {
        return task.with(state: task.state.finished(error))
    }

    func complete(error: Error?) -> SubjectTask {
        return task.with(state: task.state.finished(error))
    }

    private enum CharacteristicNotifyError: Error{
            case unExpected;
            }
}
