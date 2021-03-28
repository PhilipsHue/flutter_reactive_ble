protocol PeripheralTaskSpec {

    associatedtype Key: Equatable
    associatedtype Group = PeripheralID
    associatedtype Params
    associatedtype Stage
    associatedtype Result

    static var tag: String { get }

    static func isMember(_ key: Key, of group: Group) -> Bool
}

enum PeripheralTaskState<Stage, Result> {

    case pending
    case processing(since: Date, Stage)
    case finished(in: TimeInterval, Result)

    func processing(_ stage: Stage) -> PeripheralTaskState {
        switch self {
        case .pending:
            return .processing(since: Date(), stage)
        case .processing(let start, _):
            return .processing(since: start, stage)
        case .finished:
            assert(false, "Invalid transition: \(self) -> .processing")
            return .processing(since: .distantPast, stage)
        }
    }

    func finished(_ result: Result) -> PeripheralTaskState {
        switch self {
        case .pending:
            return .finished(in: 0, result)
        case .processing(let start, _):
            return .finished(in: -start.timeIntervalSinceNow, result)
        case .finished:
            assert(false, "Invalid transition: \(self) -> .finished")
            return .finished(in: 0, result)
        }
    }
}

struct PeripheralTask<Spec: PeripheralTaskSpec> {

    typealias Key = Spec.Key
    typealias Group = Spec.Group
    typealias Params = Spec.Params
    typealias Stage = Spec.Stage
    typealias Result = Spec.Result

    typealias State = PeripheralTaskState<Stage, Result>
    typealias Timeout = (duration: TimeInterval, handler: () -> Void)
    typealias CompletionHandler = (Result) -> Void

    let key: Key
    let params: Params
    let state: State
    let timeout: Timeout?
    let completion: CompletionHandler

    init(key: Key, params: Params, timeout: Timeout?, completion: @escaping CompletionHandler) {
        self.init(key: key, params: params, state: .pending, timeout: timeout, completion: completion)
    }

    private init(key: Key, params: Params, state: State, timeout: Timeout?, completion: @escaping CompletionHandler) {
        self.key = key
        self.params = params
        self.state = state
        self.timeout = timeout
        self.completion = completion
    }

    func with(state newState: State) -> PeripheralTask {
        return PeripheralTask(
            key: key,
            params: params,
            state: newState,
            timeout: timeout,
            completion: completion
        )
    }

    func isMember(of group: Group) -> Bool {
        return Spec.isMember(key, of: group)
    }

    func iif<T>(finished: (TimeInterval, Result) -> T, otherwise: () -> T) -> T {
        switch state {
        case .pending, .processing:
            return otherwise()
        case .finished(let duration, let result):
            return finished(duration, result)
        }
    }
}
