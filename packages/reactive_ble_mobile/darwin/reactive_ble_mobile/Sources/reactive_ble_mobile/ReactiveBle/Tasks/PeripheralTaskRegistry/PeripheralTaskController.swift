protocol PeripheralTaskController {

    associatedtype TaskSpec: PeripheralTaskSpec

    typealias SubjectTask = PeripheralTask<TaskSpec>

    init(_ task: SubjectTask)
}

extension PeripheralTaskController {

    func improperHandling(currentState: SubjectTask.State, handler: String = #function) -> Error {
        return PluginError.internalInconcictency(details: "for a task in state \(currentState) a forbidden handler \(handler) is called")
    }
}
