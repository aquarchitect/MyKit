/*
 * Schedule.swift
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
        let promise = Promise<Void>.lift {
            try handle(Double(count) * dt)
        }

        guard count != 0 else { return promise }
        return promise
            .andThen { once(dt) }
            .andThen { countdown(dt, count: count - 1, handle: handle) }
    }

    static func every(_ dt: TimeInterval, handle: @escaping (TimeInterval) throws -> Void) -> Promise<Void> {
        return countdown(dt, count: UInt.max) {
            try handle(dt * Double(UInt.max) - $0)
        }
    }
}
