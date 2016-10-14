/*
 * Schedule.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

public struct Schedule {

    public typealias Operation = (TimeInterval) throws -> Void
}

public extension Schedule {

    /// Schedule an operation for one time only, similiar to
    /// `Dispatch.main.asyncAfter`.
    ///
    /// - returns: a promise
    static func once(_ dt: TimeInterval) -> Promise<Void> {
        return Promise { callback in
            DispatchQueue.main.asyncAfter(deadline: .now() + dt) {
                callback(.fulfill())
            }
        }
    }

    /// Schedule an operation that repeats for every `dt` period of time,
    /// similiar to `Timer`. The schedule will return a successful result 
    /// after reaching the count of 0. The operation can be terminated by
    /// throwing an error inside the handle.
    ///
    /// - parameter count:   number of repeating operations
    /// - parameter handle: repeating operations with the current countdown
    ///
    /// - returns: a promise
    static func countdown(_ dt: TimeInterval, count: UInt, handle: @escaping Operation) -> Promise<Void> {
        return Promise { callback in
            func _countdown(count: UInt) {
                do {
                    try handle(dt * Double(count))
                    if count == 0 { return callback(.fulfill(())) }

                    DispatchQueue.main.asyncAfter(deadline: .now() + dt) {
                        _countdown(count: count - 1)
                    }
                } catch {
                    callback(.reject(error))
                }
            }

            _countdown(count: count)
        }
    }

    /// Schedule an operation that repeats for every `dt` period of time,
    /// similiar to `Timer`. This is an infinite schedule, and can be 
    /// terminated by throwing an error inside the handle.
    ///
    /// - parameter handle: execute every `dt` interval with the time interval
    ///
    /// - returns: a promise
    static func every(_ dt: TimeInterval, handle: @escaping Operation) -> Promise<Void> {
        return Promise { callback in
            func _every(count: UInt) {
                do {
                    try handle(dt * Double(count))
                    if count == 0 { return callback(.fulfill(())) }

                    DispatchQueue.main.asyncAfter(deadline: .now() + dt) {
                        _every(count: count + 1)
                    }
                } catch {
                    callback(.reject(error))
                }
            }

            _every(count: 0)
        }
    }
}
