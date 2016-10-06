/*
 * Promise.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Dispatch

public enum PromiseError: Error { case cancelled, empty }

/// _Promise_ represents the future value of a (usually) asynchronous task.
public struct Promise<T> {

    public typealias Operation = (@escaping Result<T>.Callback) -> Void
    fileprivate let operation: Operation

    public init(_ operation: @escaping Operation) {
        self.operation = operation
    }
}

// MARK: - Support Methods

public extension Promise {

    static func lift(_ contructor: @escaping () throws -> T) -> Promise {
        return Promise { $0(.init(contructor)) }
    }
}

// MARK: - Execution

public extension Promise {

    ///  Execute promise with a callback (for internal usage only)
    fileprivate func resolve(_ callback: @escaping Result<T>.Callback) {
        self.operation(callback)
    }

    /// Execute promise on module level
    func resolve() {
        self.operation { _ in }
    }
}

// MARK: - Transformation

public extension Promise {

    /// Transform one type to another.
    func map<U>(_ transformer: @escaping (T) throws -> U) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve { result in
                callback(result.map(transformer))
            }
        }
    }

    /// Transform one type to another.
    func flatMap<U>(_ transformer: @escaping (T) -> Promise<U>) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve { result in
                do {
                    try (result.resolve >>> transformer)().resolve(callback)
                } catch {
                    callback(.reject(error))
                }
            }
        }
    }
}

// MARK: - Result Action

public extension Promise {

    private func onResult(_ handler: @escaping (Result<T>) -> Void) -> Promise {
        return Promise { callback in
            self.resolve { result in
                handler(result)
                callback(result)
            }
        }
    }

    func always(_ handler: @escaping () -> Void) -> Promise {
        return onResult { _ in handler() }
    }

    func onSuccess(_ handler: @escaping (T) -> Void) -> Promise {
        return onResult {
            if case .fulfill(let value) = $0 { handler(value) }
        }
    }

    func onFailure(_ handler: @escaping (Error) -> Void) -> Promise {
        return onResult {
            if case .reject(let error) = $0 { handler(error) }
        }
    }
}

// MARK: - Failure Action

public extension Promise {

    func recover(_ transformer: @escaping (Error) -> Promise) -> Promise {
        return Promise { callback in
            self.resolve { result in
                do {
                    callback(.fulfill(try result.resolve()))
                } catch {
                    transformer(error).resolve(callback)
                }
            }
        }
    }

    func retry(attempCount count: Int) -> Promise {
        return Promise { callback in
            func _retry(attemptCount count: Int) {
                self.resolve { result in
                    switch (result, count) {
                    case (.fulfill(_), _), (.reject(_), 0): callback(result)
                    default: _retry(attemptCount: count - 1)
                    }
                }
            }

            _retry(attemptCount: count)
        }
    }
}

// MARK: - Threading

public extension Promise {

    func inBackground() -> Promise {
        return Promise { callback in
            DispatchQueue.global(qos: .background).async {
                self.resolve { result in
                    DispatchQueue.main.sync {
                        callback(result)
                    }
                }
            }
        }
    }

    func inDispatchGroup(_ group: DispatchGroup) -> Promise {
        return Promise { callback in
            group.enter()
            self.resolve { result in
                callback(result)
                group.leave()
            }
        }
    }
}

// MARK: - Multiple Promises

public extension Promise {

    /// Execute promises of the same type asynchronously.
    static func concat(_ promises: [Promise]) -> Promise<[T]> {
        let group = DispatchGroup()

        return Promise<[T]> { callback in
            var outputs: [Result<T>] = []

            for promise in promises {
                promise
                    .inDispatchGroup(group)
                    .resolve { outputs.append($0) }
            }

            group.notify(queue: .main) {
                callback(Result.concat(outputs))
            }
        }
    }

    static func concat(_ promises: Promise...) -> Promise<[T]> {
        return concat(promises)
    }
}

/// Execute promises of different tpes asynchronously
public func zip<A, B>(_ promiseA: Promise<A>, _ promiseB: Promise<B>) -> Promise<(A, B)> {
    let group = DispatchGroup()

    return Promise<(A, B)> { callback in
        var resultA: Result<A>!, resultB: Result<B>!

        promiseA
            .inDispatchGroup(group)
            .resolve { resultA = $0 }

        promiseB
            .inDispatchGroup(group)
            .resolve { resultB = $0 }

        group.notify(queue: .main) {
            callback(zip(resultA, resultB))
        }
    }
}
