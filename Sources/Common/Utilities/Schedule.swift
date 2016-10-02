/*
 * Schedule.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

public struct Schedule {}

public extension Schedule {

    static func once(_ dt: TimeInterval) -> Promise<Void> {
        return Promise { callback in
            DispatchQueue.main.asyncAfter(deadline: .now() + dt) {
                callback(.fullfill())
            }
        }
    }

    static func countdown(_ dt: TimeInterval, count: UInt, handle: @escaping (TimeInterval) throws -> Void) -> Promise<Void> {
        return Promise { (callback: @escaping Result.Callback) in
            func _countdown(count: UInt) {
                do {
                    try handle(dt * Double(count))

                    if count == 0 { return callback(.fullfill(())) }

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

    static func every(_ dt: TimeInterval, handle: @escaping (TimeInterval) throws -> Void) -> Promise<Void> {
        return Promise { (callback: @escaping Result.Callback) in
            func _every(count: UInt) {
                do {
                    try handle(dt * Double(count))

                    if count == 0 { return callback(.fullfill(())) }

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
