struct StreamingTask<T> {
    let parameters: T
    let sink: EventSink?

    init(parameters: T) {
        self.parameters = parameters
        self.sink = nil
    }

    private init(parameters: T, sink: EventSink?) {
        self.parameters = parameters
        self.sink = sink
    }

    func with(sink: EventSink?) -> StreamingTask {
        return StreamingTask(parameters: parameters, sink: sink)
    }
}
