/*
 * Promise.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Dispatch

public enum PromiseError: Error { case cancelled, empty }

public struct Promise<T> {

    public typealias Operation = (@escaping Result<T>.Callback) -> Void
    fileprivate let operation: Operation

    public init(_ operation: @escaping Operation) {
        self.operation = operation
    }
}

// MARK: - Support Methods

public extension Promise {

    /** 
     * Execute promise with a callback
     */
    fileprivate func resolve(_ callback: @escaping Result<T>.Callback) {
        self.operation(callback)
    }

    func resolve() {
        self.operation { _ in }
    }
}

public extension Promise {

    /**
     * Transform value type
     */
    func map<U>(_ transform: @escaping (T) throws -> U) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve { result in
                callback(result.map(transform))
            }
        }
    }

    /**
     * Transform promise type
     */
    func flatMap<U>(_ transform: @escaping (T) -> Promise<U>) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve { result in
                do {
                    try (result.resolve >>> transform)().resolve(callback)
                } catch {
                    callback(.reject(error))
                }
            }
        }
    }
}

public extension Promise {

    private func onResult(_ execute: @escaping (Result<T>) -> Void) -> Promise {
        return Promise { callback in
            self.resolve { result in
                execute(result)
                callback(result)
            }
        }
    }

    func always(_ execute: @escaping () -> Void) -> Promise {
        return onResult { _ in execute() }
    }

    func onSuccess(_ execute: @escaping (T) -> Void) -> Promise {
        return onResult {
            if case .fulfill(let value) = $0 { execute(value) }
        }
    }

    func onFailure(_ execute: @escaping (Error) -> Void) -> Promise {
        return onResult {
            if case .reject(let error) = $0 { execute(error) }
        }
    }
}

public extension Promise {

    func recover(_ transform: @escaping (Error) -> Promise) -> Promise {
        return Promise { callback in
            self.resolve { result in
                do {
                    callback(.fulfill(try result.resolve()))
                } catch {
                    transform(error).resolve(callback)
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

public extension Promise {

    static func lift(_ contruct: @escaping () throws -> T) -> Promise {
        return Promise { $0(.init(contruct)) }
    }
}

// MARK: - Multiple Promises

public extension Promise {

    /**
     * Queue up promises asynchronously
     */
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

/**
 * Queue up promises of 2 dirrent types aysnchronously
 */
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
