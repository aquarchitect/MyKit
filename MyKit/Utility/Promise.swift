//
//  Promise.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/18/16.
//  
//

infix operator +++ { associativity left }

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

    private func joint<U>(queue: dispatch_queue_t, _ group: dispatch_group_t, f: ((T throws -> U) -> Result<U>) -> Void) {
        dispatch_group_enter(group)

        resolve { result in
            dispatch_barrier_sync(queue) { f(result.then) }
            dispatch_group_leave(group)
        }
    }

    static public func when(promises: [Promise]) -> Promise<[T]> {
        let queue = dispatch_queue_create("HaiNguyen.MyKit.Promise.array", DISPATCH_QUEUE_CONCURRENT)
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

public func +++ <A, B>(lhs: Promise<A>, rhs: Promise<B>) -> Promise<(A, B)> {
    let queue = dispatch_queue_create("HaiNguyen.MyKit.Promise.tuple", DISPATCH_QUEUE_CONCURRENT)
    let group = dispatch_group_create()

    var output: Result<(A?, B?)>?

    return Promise<(A, B)> { callback in
        lhs.joint(queue, group) { output = $0 { ($0, try output?.resolve().1) }}
        rhs.joint(queue, group) { output = $0 { (try output?.resolve().0, $0) }}

        dispatch_group_notify(group, queue) {
            switch output {

            case .Fullfill(let a?, let b?)?: callback(.Fullfill((a, b)))
            case .Reject(let error)?: callback(.Reject(error))
            default: break
            }
        }
    }
}