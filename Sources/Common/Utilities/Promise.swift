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

    /// Execute promise operation with a callback
    public func resolve(callback: Result<T>.Callback) {
        self.operation(callback)
    }

    /// Transform the promise from one type to another
    public func then<U>(f: T -> U) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve { callback($0.then(f)) }
        }
    }

    /// Transform the promise from one type to another with a potential error
    public func then<U>(f: T throws -> U) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve { callback($0.then(f)) }
        }
    }

    /// Transform to another promise
    public func andThen<U>(f: T -> Promise<U>) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve {
                do { try ($0.resolve >>> f)().resolve(callback) }
                catch { callback(.Reject(error)) }
            }
        }
    }

    /// Transform to another promise with a potential error
    public func andThen<U>(f: T throws -> Promise<U>) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve {
                do { try ($0.resolve >>> f)().resolve(callback) }
                catch { callback(.Reject(error)) }
            }
        }
    }
}

// MARK: Multiple Promises

public extension Promise {

    // execute promises concurrently with a group-dispatch monitoring
    private func joint<U>(queue: dispatch_queue_t, _ group: dispatch_group_t, f: ((T throws -> U) -> Result<U>) -> Void) {
        dispatch_group_enter(group)

        resolve { result in
            dispatch_barrier_sync(queue) { f(result.then) }
            dispatch_group_leave(group)
        }
    }

    /// Convert concurrent promises of a same type to a promise of an array
    static public func when(promises: [Promise]) -> Promise<[T]> {
        let queue = dispatch_queue_create("MyKit.Promise.array", DISPATCH_QUEUE_CONCURRENT)
        let group = dispatch_group_create()

        var output: Result<[T]>?

        return Promise<[T]> { callback in
            promises.forEach { $0.joint(queue, group) {
                output = $0 { (try output?.resolve() ?? []) + [$0] }
            }}

            dispatch_group_notify(group, queue) {
                if let result = output { callback(result) }
            }
        }
    }
}

infix operator +++ { associativity left }

/// Convert concurrent promises of 2 different types to a promise of tuple
public func +++ <A, B>(lhs: Promise<A>, rhs: Promise<B>) -> Promise<(A, B)> {
    let queue = dispatch_queue_create("MyKit.Promise.tuple", DISPATCH_QUEUE_CONCURRENT)
    let group = dispatch_group_create()

    var output: Result<(A?, B?)>?

    return Promise<(A, B)> { callback in
        lhs.joint(queue, group) { output = $0 { ($0, try output?.resolve().1) }}
        rhs.joint(queue, group) { output = $0 { (try output?.resolve().0, $0) }}

        dispatch_group_notify(group, queue) {
            switch output {

            case .Fullfill(let a?, let b?)?: callback(.Fullfill((a, b)))
            case .Reject(let error)?: callback(.Reject(error))
            default: callback(.Reject(Error.NoDataContent))
            }
        }
    }
}