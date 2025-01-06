enum Failable<T> {

    case success(T)
    case failure(Error)

    var value: T? { return iif(success: id, failure: const(nil)) }
    var error: Error? { return iif(success: const(nil), failure: id) }

    func iif<U>(success: (T) -> U, failure: (Error) -> U) -> U {
        switch self {
        case .success(let value):
            return success(value)
        case .failure(let error):
            return failure(error)
        }
    }
}
