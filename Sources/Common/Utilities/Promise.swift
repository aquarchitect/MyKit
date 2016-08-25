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

// MARK: - Support Methods

public extension Promise {

    /** 
     * Execute promise with a callback
     */
    func resolve(callback: Result<T>.Callback) {
        self.operation(callback)
    }

    /**
     * Transform value type
     */
    func then<U>(f: T throws -> U) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve { callback($0.then(f)) }
        }
    }

    /**
     * Transform promise type
     */
    func andThen<U>(f: T throws -> Promise<U>) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve {
                do { try ($0.resolve >>> f)().resolve(callback) }
                catch { callback(.Reject(error)) }
            }
        }
    }

    /**
     * Transform promise type in a raw way
     */
    func andThen<U>(f: T throws -> Result<U>.Callback -> Void) -> Promise<U> {
        return andThen { value in Promise<U>(try f(value)) }
    }
}

// MARK: - Multiple Promises

public extension Promise {

    /**
     * Execute promises concurrently
     */
    internal func joint<U>(queue: dispatch_queue_t, _ group: dispatch_group_t, f: ((T throws -> U) -> Result<U>) -> Void) {
        dispatch_group_enter(group)

        resolve { result in
            dispatch_barrier_sync(queue) { f(result.then) }
            dispatch_group_leave(group)
        }
    }

    /**
     * Queue up promises asynchronously
     */
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

    static func when(promises: Promise...) -> Promise<[T]> {
        return when(promises)
    }
}

infix operator +++ { associativity left }

/**
 * Queue up promises of 2 dirrent types aysnchronously
 */
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
            default: return
            }
        }
    }
}