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
            let service = peripheral.services?.first(where: { $0.uuid == task.key.serviceID }),
            let characteristic = service.characteristics?.first(where: { $0.uuid == task.key.id }),
            characteristic.properties.contains(.write)
        else {
            return task.with(state: task.state.finished(PluginError.internalInconcictency(details: nil)))
        }

        // print out the value's length in bytes
        print("value length: \(task.params.value.count)")

        print("WithResponse maximum write value length: \(peripheral.maximumWriteValueLength(for: .withResponse))")

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
