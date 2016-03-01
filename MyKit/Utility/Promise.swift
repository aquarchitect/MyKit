//
//  Promise.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/18/16.
//  
//

public struct Promise<T> {

    private let operation: Result<T>.Callback -> Void

    public init(_ operation: Result<T>.Callback -> Void) {
        self.operation = operation
    }
}

public extension Promise {

    public func resolve(callback: Result<T>.Callback) {
        self.operation(callback)
    }

    public func then<U>(f: T -> U) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve { callback($0.then(f)) }
        }
    }

    public func then<U>(f: T throws -> U) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve { callback($0.then(f)) }
        }
    }

    public func andThen<U>(f: T -> Promise<U>) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve {
                do { try ($0.resolve >>> f)().resolve(callback) }
                catch { callback(.Reject(error)) }
            }
        }
    }

    public func andThen<U>(f: T throws -> Promise<U>) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve {
                do { try ($0.resolve >>> f)().resolve(callback) }
                catch { callback(.Reject(error)) }
            }
        }
    }
}

public func combine<T>(promises: Promise<T>...) -> Promise<[T]> {
    var _values: [T] = []
    var _error: ErrorType?

    let group = dispatch_group_create()
    let queue = dispatch_queue_create("Execution", DISPATCH_QUEUE_CONCURRENT)

    return Promise { callback in
        for promise in promises {
            dispatch_group_enter(group)

            promise.resolve { result in
                dispatch_barrier_sync(queue) {
                    switch result {

                    case .Fullfill(let value): _values.append(value)
                    case .Reject(let error): _error = error
                    }
                }
                dispatch_group_leave(group)
            }
        }

        dispatch_group_notify(group, queue) {
            if let error = _error {
                callback(.Reject(error))
            } else {
                callback(.Fullfill(_values))
            }
        }
    }
}