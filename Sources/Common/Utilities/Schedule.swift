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
}

public extension Schedule {

    static func countdown(_ dt: TimeInterval, count: UInt, handle: @escaping (TimeInterval) throws -> Void) -> Promise<Void> {
        let promise = Promise<Void>.lift {
            try handle(Double(count) * dt)
        }

        guard count != 0 else { return promise }
        return promise
            .andThen { once(dt) }
            .andThen { countdown(dt, count: count - 1, handle: handle) }
    }
}

public extension Schedule {

    static func every(_ dt: TimeInterval, handle: @escaping (TimeInterval) throws -> Void) -> Promise<Void> {
        func every(count: UInt) -> Promise<Void> {
            return once(dt)
                .then { try handle(Double(count + 1) * dt) }
                .andThen { every(count: count + 1) }
        }

        return every(count: 0)
    }
}
