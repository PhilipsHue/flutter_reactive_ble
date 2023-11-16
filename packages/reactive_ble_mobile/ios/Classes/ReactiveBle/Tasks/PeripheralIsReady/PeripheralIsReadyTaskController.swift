import CoreBluetooth

struct PeripheralIsReadyTaskController: PeripheralTaskController {

    typealias TaskSpec = PeripheralIsReadyTaskSpec

    private let task: SubjectTask

    init(_ task: SubjectTask) {
        self.task = task
    }

    func start(peripheral: CBPeripheral,
               characteristic qualifiedCharacteristic: CharacteristicInstance) -> SubjectTask {
        guard
            peripheral.state == .connected,
            let service = peripheral.services?.first(where: { $0.uuid == qualifiedCharacteristic.serviceID }),
            let characteristic = service.characteristics?.first(where: { $0.uuid == qualifiedCharacteristic.id }),
            characteristic.properties.contains(.writeWithoutResponse)
        else {
            return task.with(state: task.state.finished(PluginError.internalInconcictency(details: nil)))
        }

        peripheral.writeValue(task.params.value, for: characteristic, type: .withoutResponse)
        
        return task.with(state: task.state.processing(.writing))
    }

    func cancel(error: Error) -> SubjectTask {
        return task.with(state: task.state.finished(error))
    }

    func handleWrite(error: Error?) -> SubjectTask {
        return task.with(state: task.state.finished(error))
    }
}
