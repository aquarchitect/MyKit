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

    static func when(promises: Promise...) -> Promise<[T]> {
        return when(promises)
    }

    /// Convert concurrent promises of a same type to a promise of an array
    static func when(promises: [Promise]) -> Promise<[T]> {
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

// Convert concurrent promises of 2 different types to a promise of tuple
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