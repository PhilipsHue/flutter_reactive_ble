import CoreBluetooth

struct CharacteristicWriteTaskController: PeripheralTaskController {

    typealias TaskSpec = CharacteristicWriteTaskSpec

    private let task: Task

    init(_ task: Task) {
        self.task = task
    }

    func start(peripheral: CBPeripheral) -> Task {
        guard
            peripheral.state == .connected,
            let service = peripheral.services?.first(where: { $0.uuid == task.key.serviceID }),
            let characteristic = service.characteristics?.first(where: { $0.uuid == task.key.id }),
            characteristic.properties.contains(.write)
        else {
            return task.with(state: task.state.finished(PluginError.internalInconcictency(details: nil)))
        }

        peripheral.writeValue(task.params.value, for: characteristic, type: .withResponse)

        return task.with(state: task.state.processing(.writing))
    }

    func cancel(error: Error) -> Task {
        return task.with(state: task.state.finished(error))
    }

    func handleWrite(error: Error?) -> Task {
        return task.with(state: task.state.finished(error))
    }
}
