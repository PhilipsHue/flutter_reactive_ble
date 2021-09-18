import Foundation

final class PeripheralTaskRegistry<Controller: PeripheralTaskController> {

    typealias SubjectTask = Controller.SubjectTask
    typealias TaskCompletionHandler = (SubjectTask.Key, SubjectTask.Params, SubjectTask.Result) -> Void

    private var tasks = TaskQueue()
    private var scheduledTimeouts = [TaskQueue.Record.UniqueID: Timer]()

    var log: (String) -> Void = { _ in }

    func registerTask(
        key: SubjectTask.Key,
        params: SubjectTask.Params,
        timeout: SubjectTask.Timeout? = nil,
        completion: @escaping SubjectTask.CompletionHandler
    ) {
        let task = SubjectTask(
            key: key,
            params: params,
            timeout: timeout,
            completion: completion
        )
        tasks.add(task)
        log("\(Controller.TaskSpec.tag) op enqueued, \(tasks.count) in queue, \(tasks.totalAdded) have been added over the lifetime")
    }

    func updateTask(
        key: SubjectTask.Key,
        action: (Controller) -> SubjectTask
    ) {
        guard let record = tasks.firstWith(key: key)
        else { return }

        let taskController = Controller(record.task)
        let updatedTask = action(taskController)

        updatedTask.iif(
            finished: { duration, result in
                log("\(Controller.TaskSpec.tag) op finished in \(duration) s, \(tasks.count - 1) in queue")
                updatedTask.completion(result)
                remove(record.uniqueID)
            },
            otherwise: {
                tasks.update(record.with(task: updatedTask))
                if  case .pending = record.task.state,
                    case .processing = updatedTask.state,
                    let timeout = record.task.timeout
                {
                    scheduleTaskTimeout(record.uniqueID, timeout)
                }
            }
        )
    }

    func updateTasks(
        in group: SubjectTask.Group,
        action: (Controller) -> SubjectTask
    ) {
        tasks.update(where: { $0.isMember(of: group) }) { record in
            let taskController = Controller(record.task)
            let updatedTask = action(taskController)

            updatedTask.iif(
                finished: { duration, result in
                    log("\(Controller.TaskSpec.tag) op finished in \(duration) s, \(tasks.count - 1) in queue")
                    updatedTask.completion(result)
                    remove(record.uniqueID)
                },
                otherwise: {
                    tasks.update(record.with(task: updatedTask))
                }
            )
        }
    }

    private func remove(_ uniqueID: TaskQueue.Record.UniqueID) {
        clearTimeout(uniqueID)
        tasks.remove(uniqueID)
    }

    private func clearTimeout(_ uniqueID: TaskQueue.Record.UniqueID) {
        if let timer = scheduledTimeouts.removeValue(forKey: uniqueID) {
            timer.invalidate()
        }
    }

    private func scheduleTaskTimeout(_ uniqueID: TaskQueue.Record.UniqueID, _ timeout: SubjectTask.Timeout) {
        let timer = Timer.scheduledTimer(
            withTimeInterval: timeout.duration,
            repeats: false,
            block: papply(weak: self) { registry, _ in
                registry.log("\(Controller.TaskSpec.tag) op timed out after \(timeout.duration) s, \(registry.tasks.count - 1) in queue")
                timeout.handler()
                registry.remove(uniqueID)
            }
        )
        scheduledTimeouts[uniqueID] = timer
    }

    private class TaskQueue {

        private let counter = Counter()
        private var records = [Record]()

        var count: Int { return records.count }
        var totalAdded: Int { return counter.value }

        func add(_ task: SubjectTask) {
            records.append(Record(
                uniqueID: counter.increment(),
                task: task
            ))
        }

        func firstWith(key: SubjectTask.Key) -> Record? {
            return records.first(where: { $0.task.key == key })
        }

        func firstWith(uniqueID: Record.UniqueID) -> Record? {
            return records.first(where: { $0.uniqueID == uniqueID })
        }

        func update(_ record: Record) {
            guard let index = records.firstIndex(where: { $0.uniqueID == record.uniqueID })
            else { return }

            records[index] = record
        }

        func update(where p: (SubjectTask) -> Bool, _ body: (Record) -> Void) {
            Array(records)
                .filter({ p($0.task) })
                .forEach(body)
        }

        func remove(_ uniqueID: Record.UniqueID) {
            guard let index = records.firstIndex(where: { $0.uniqueID == uniqueID })
            else { return }

            records.remove(at: index)
        }

        struct Record {

            typealias UniqueID = Int

            let uniqueID: UniqueID
            let task: SubjectTask

            func with(task: SubjectTask) -> Record {
                return .init(uniqueID: uniqueID, task: task)
            }
        }
    }

    private class Counter {

        private(set) var value = 0

        func increment() -> Int {
            value += 1
            return value
        }
    }
}
