protocol PeripheralTaskController {

    associatedtype TaskSpec: PeripheralTaskSpec

    typealias Task = PeripheralTask<TaskSpec>

    init(_ task: Task)
}

extension PeripheralTaskController {

    func improperHandling(currentState: Task.State, handler: String = #function) -> Error {
        return PluginError.internalInconcictency(details: "for a task in state \(currentState) a forbidden handler \(handler) is called")
    }
}
