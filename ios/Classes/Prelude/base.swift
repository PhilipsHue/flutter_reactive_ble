func id<T>(_ some: T) -> T {
    return some
}

func const<T, U>(_ value: U) -> (T) -> U {
    return { (_: T) -> U in value }
}

func const<U>(_ value: U) -> () -> U {
    return { () -> U in value }
}
