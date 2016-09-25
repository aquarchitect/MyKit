/*
 * Promise.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Dispatch

public enum PromiseError: Error { case noData }

public struct Promise<T> {

    fileprivate let operation: (@escaping Result<T>.Callback) -> Void

    public init(_ operation: @escaping (@escaping Result<T>.Callback) -> Void) {
        self.operation = operation
    }
}

// MARK: - Support Methods

public extension Promise {

    /** 
     * Execute promise with a callback
     */
    func resolve(_ callback: Result<T>.Callback? = nil) {
        self.operation { result in
            callback?(result)
        }
    }
}

public extension Promise {

    /**
     * Transform value type
     */
    func then<U>(_ transform: @escaping (T) throws -> U) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve { result in
                callback(result.then(transform))
            }
        }
    }

    /**
     * Transform promise type
     */
    func andThen<U>(_ transform: @escaping (T) -> Promise<U>) -> Promise<U> {
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

    func onResult(_ execute: @escaping (Result<T>) -> Void) -> Promise {
        return Promise { callback in
            self.resolve { result in
                execute(result)
                callback(result)
            }
        }
    }

    func onSuccess(_ execute: @escaping (T) -> Void) -> Promise {
        return onResult {
            if case .fullfill(let value) = $0 { execute(value) }
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
                    callback(.fullfill(try result.resolve()))
                } catch {
                    transform(error).resolve(callback)
                }
            }
        }
    }

    func retry(attempCount count: Int) -> Promise {
        return Promise { callback in
            self.resolve { result in
                do {
                    callback(.fullfill(try result.resolve()))
                } catch {
                    if count == 0 {
                        callback(.reject(error))
                    } else {
                        self.retry(attempCount: count - 1).resolve(callback)
                    }
                }
            }
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

// MARK: - Multiple Promises

public extension Promise {

    /**
     * Queue up promises asynchronously
     */
    static func when(_ promises: [Promise]) -> Promise<[T]> {
        let group = DispatchGroup()

        return Promise<[T]> { callback in
            var outputs: [Result<T>] = []

            for promise in promises {
                promise.inDispatchGroup(group).resolve { result in
                    outputs.append(result)
                }
            }

            group.notify(queue: .main) {
                callback(Result<T>.zip(outputs))
            }
        }
    }

    static func when(_ promises: Promise...) -> Promise<[T]> {
        return when(promises)
    }

    static func lift(_ construct: @escaping () throws -> T) -> Promise {
        return Promise { callback in
            callback(.init(construct: construct))
        }
    }
}

/**
 * Queue up promises of 2 dirrent types aysnchronously
 */
public func when<A, B>(_ promiseA: Promise<A>, _ promiseB: Promise<B>) -> Promise<(A, B)> {
    let group = DispatchGroup()

    return Promise<(A, B)> { callback in
        var resultA: Result<A>!, resultB: Result<B>!

        promiseA.inDispatchGroup(group).resolve { result in
            resultA = result
        }

        promiseB.inDispatchGroup(group).resolve { result in
            resultB = result
        }

        group.notify(queue: .main) {
            callback(zip(resultA, resultB))
        }
    }
}
