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

    static func once(dt: NSTimeInterval, block: () -> Void) {
        let poptime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * dt))

        dispatch_after(poptime, Queue.Main, block)
    }

    static func once(dt: NSTimeInterval) -> Promise<Void> {
        return Promise { callback in
            once(dt) { callback(.Fullfill(())) }
        }
    }

    static func every(dt: NSTimeInterval, block: () throws -> Void) -> Promise<Void> {
        return once(dt)
            .then(block)
            .andThen { every(dt, block: block) }
    }

    static func countdown(dt: NSTimeInterval, count: UInt, block: (remaining: NSTimeInterval) throws -> Void) -> Promise<Void> {
        let promise = Promise<Void>.lift {
            try block(remaining: Double(count) * dt)
        }

        guard count != 0 else { return promise }
        return promise
            .andThen { once(dt) }
            .andThen { countdown(dt, count: count - 1, block: block) }
    }
}