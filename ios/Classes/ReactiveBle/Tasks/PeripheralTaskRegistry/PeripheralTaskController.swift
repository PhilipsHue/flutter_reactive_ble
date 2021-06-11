protocol PeripheralTaskController {

    associatedtype TaskSpec: PeripheralTaskSpec

    typealias PTask = PeripheralTask<TaskSpec>

    init(_ task: PTask)
}

extension PeripheralTaskController {

    func improperHandling(currentState: PTask.State, handler: String = #function) -> Error {
        return PluginError.internalInconcictency(details: "for a task in state \(currentState) a forbidden handler \(handler) is called")
    }
}
