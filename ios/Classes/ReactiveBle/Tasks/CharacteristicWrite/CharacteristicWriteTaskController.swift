import CoreBluetooth

struct CharacteristicWriteTaskController: PeripheralTaskController {

    typealias TaskSpec = CharacteristicWriteTaskSpec

    private let task: PTask

    init(_ task: PTask) {
        self.task = task
    }

    func start(peripheral: CBPeripheral) -> PTask {
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

    func cancel(error: Error) -> PTask {
        return task.with(state: task.state.finished(error))
    }

    func handleWrite(error: Error?) -> PTask {
        return task.with(state: task.state.finished(error))
    }
}
