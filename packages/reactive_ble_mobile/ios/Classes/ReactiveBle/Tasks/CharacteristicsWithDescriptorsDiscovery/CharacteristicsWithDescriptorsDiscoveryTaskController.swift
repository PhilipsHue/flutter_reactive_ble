import CoreBluetooth

struct CharacteristicsWithDescriptorsDiscoveryTaskController: PeripheralTaskController {

    typealias TaskSpec = CharacteristicsWithDescriptorsDiscoveryTaskSpec

    private let task: SubjectTask

    init(_ task: SubjectTask) {
        self.task = task
    }

    func start(peripheral: CBPeripheral) -> SubjectTask {
        guard case .pending = task.state
        else {
            return task
                .with(state: task.state.finished([
                    improperHandling(currentState: task.state)
                ]))
        }

        if task.params.characteristicsWithDescriptorsToDiscover.isEmpty {
            return task.with(state: task.state.finished([]))
        } else {
            let toDiscover = task.params.characteristicsWithDescriptorsToDiscover.characteristics
            
            for characteristic in toDiscover {
                peripheral.discoverDescriptors(for: characteristic)
            }

            return task.with(state: task.state.processing(.discoveringDescriptors(characteristicsLeft: toDiscover.count, errors: [])))
        }
    }

    func cancel(error: Error) -> SubjectTask {
        return task
            .with(state: task.state.finished([error]))
    }

    func handleDiscovery(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?) -> SubjectTask {
        guard case .processing(since: _, .discoveringDescriptors(let characteristicsLeft, _)) = task.state
        else {
            return task
                .with(state: task.state.finished([
                    improperHandling(currentState: task.state)
                ]))
        }
        
        if let error = error {
            return task
                .with(state: task.state.finished([error]))
        } else {
            return task
                .with(state: characteristicsLeft > 0
                      ? task.state.processing(.discoveringDescriptors(
                        characteristicsLeft: characteristicsLeft - 1,
                        errors: []
                      ))
                      : task.state.finished([])
                )
        }
    }
}
