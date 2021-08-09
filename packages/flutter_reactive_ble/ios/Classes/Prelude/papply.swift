func papply<T1: AnyObject, T2, T3, T4, T5>(weak arg1: T1, _ f: @escaping (T1, T2, T3, T4, T5) -> Void) -> (T2, T3, T4, T5) -> Void {
    return { [weak arg1] (arg2: T2, arg3: T3, arg4: T4, arg5: T5) -> Void in
        guard let arg1 = arg1
        else { return }

        f(arg1, arg2, arg3, arg4, arg5)
    }
}

func papply<T1: AnyObject, T2, T3, T4>(weak arg1: T1, _ f: @escaping (T1, T2, T3, T4) -> Void) -> (T2, T3, T4) -> Void {
    return { [weak arg1] (arg2: T2, arg3: T3, arg4: T4) -> Void in
        guard let arg1 = arg1
        else { return }

        f(arg1, arg2, arg3, arg4)
    }
}

func papply<T1: AnyObject, T2, T3>(weak arg1: T1, _ f: @escaping (T1, T2, T3) -> Void) -> (T2, T3) -> Void {
    return { [weak arg1] (arg2: T2, arg3: T3) -> Void in
        guard let arg1 = arg1
        else { return }

        f(arg1, arg2, arg3)
    }
}

func papply<T1: AnyObject, T2>(weak arg1: T1, _ f: @escaping (T1, T2) -> Void) -> (T2) -> Void {
    return { [weak arg1] (arg2: T2) -> Void in
        guard let arg1 = arg1
        else { return }

        f(arg1, arg2)
    }
}

func papply<T1: AnyObject>(weak arg1: T1, _ f: @escaping (T1) -> Void) -> () -> Void {
    return { [weak arg1] () -> Void in
        guard let arg1 = arg1
        else { return }

        f(arg1)
    }
}
