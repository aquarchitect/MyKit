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

import Foundation

enum PromiseError: ErrorType {

    case NoContent
    case Cancelled
}

public struct Promise<T> {

    private let operation: Result<T>.Callback -> Void

    public init(_ operation: Result<T>.Callback -> Void) {
        self.operation = operation
    }
}

// MARK: - Support Methods

public extension Promise {

    /** 
     * Execute promise with a callback
     */
    func resolve(callback: Result<T>.Callback) {
        self.operation(callback)
    }

    func resolve(callback: Result<T>.Callback? = nil) {
        self.operation { result in
            callback?(result)
        }
    }
}

public extension Promise {

    /**
     * Transform value type
     */
    func then<U>(f: T throws -> U) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve { result in
                callback(result.then(f))
            }
        }
    }

    /**
     * Transform promise type
     */
    func andThen<U>(f: T -> Promise<U>) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve { result in
                do {
                    try (result.resolve >>> f)().resolve(callback)
                } catch {
                    callback(.Reject(error))
                }
            }
        }
    }
}

public extension Promise {

    func onSuccess(f: T -> Void) -> Promise {
        return Promise { callback in
            self.resolve { result in
                if case .Fullfill(let value) = result {
                    f(value)
                }
                callback(result)
            }
        }
    }

    func onFailure(f: ErrorType -> Void) -> Promise {
        return Promise { callback in
            self.resolve { result in
                if case .Reject(let error) = result {
                    f(error)
                }
                callback(result)
            }
        }
    }
}

public extension Promise {

    func recover(f: ErrorType -> Promise) -> Promise {
        return Promise { callback in
            self.resolve { result in
                do {
                    callback(.Fullfill(try result.resolve()))
                } catch {
                    f(error).resolve(callback)
                }
            }
        }
    }

    func retry(attempCount count: Int) -> Promise {
        return Promise { callback in
            self.resolve { result in
                do {
                    callback(.Fullfill(try result.resolve()))
                } catch {
                    if count == 0 {
                        callback(.Reject(error))
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
            dispatch_async(Queue.Global.Background) {
                self.resolve { result in
                    dispatch_async(Queue.Main) {
                        callback(result)
                    }
                }
            }
        }
    }

    func inDispatchGroup(group: dispatch_group_t) -> Promise {
        return Promise { callback in
            dispatch_group_enter(group)
            self.resolve { result in
                callback(result)
                dispatch_group_leave(group)
            }
        }
    }
}

// MARK: - Multiple Promises

public extension Promise {

    /**
     * Queue up promises asynchronously
     */
    static func when(promises: [Promise]) -> Promise<[T]> {
        let group = dispatch_group_create()

        return Promise<[T]> { callback in
            var outputs: [Result<T>] = []

            for promise in promises {
                promise.inDispatchGroup(group).resolve { result in
                    outputs.append(result)
                }
            }

            dispatch_group_notify(group, Queue.Main) {
                callback(Result<T>.zip(outputs))
            }
        }
    }
}

/**
 * Queue up promises of 2 dirrent types aysnchronously
 */
public func when<A, B>(promiseA: Promise<A>, _ promiseB: Promise<B>) -> Promise<(A, B)> {
    let group = dispatch_group_create()

    return Promise<(A, B)> { callback in
        var resultA: Result<A>!, resultB: Result<B>!

        promiseA.inDispatchGroup(group).resolve { result in
            resultA = result
        }

        promiseB.inDispatchGroup(group).resolve { result in
            resultB = result
        }

        dispatch_group_notify(group, Queue.Main) {
            callback(zip(resultA, resultB))
        }
    }
}