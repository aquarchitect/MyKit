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

final public class Schedule {

    public typealias ID = UInt

    public struct Task {

        public private(set) var intervals: AnyGenerator<NSTimeInterval>

        public var isSuspended = false
        let block: () -> Void
    }

    private static let sharedInstance = Schedule()
    private static var trackedID: ID = 0

    private(set) static var subscribers: [ID: Task] = [:]

    private func runTask(id: ID) {
        objc_sync_enter(Schedule.sharedInstance)
        defer { objc_sync_exit(Schedule.sharedInstance) }

        guard let task = Schedule.subscribers[id] where !task.isSuspended else { return }
        task.block()

        if let interval = task.intervals.next() {
            Schedule.dispatch(id, interval: interval)
        } else {
            Schedule.subscribers.removeValueForKey(id)
        }
    }
}

private extension Schedule {

    static func dispatch(intervals: AnyGenerator<NSTimeInterval>, block: Void -> Void) -> ID {
        objc_sync_enter(sharedInstance)
        defer { objc_sync_exit(sharedInstance) }

        trackedID += 1 // started at one not 0; fail-safe for canceling at 0

        subscribers[trackedID] = Task(intervals: intervals, block: block)

        if let interval = intervals.next() {
            dispatch(trackedID, interval: interval)
        }

        return trackedID
    }

    static func dispatch(id: ID, interval: NSTimeInterval) {
        delay(interval) { sharedInstance.runTask(id) }
    }
}

public extension Schedule {

    static func task(`for` id: ID) -> Task? {
        return subscribers[id]
    }

    static func cancel(ids: ID...) -> [Bool] {
        objc_sync_enter(sharedInstance)
        defer { objc_sync_exit(sharedInstance) }

        return ids.map { subscribers.removeValueForKey($0) != nil }
    }

    static func suspend(ids: ID...) -> [Bool] {
        objc_sync_enter(sharedInstance)
        defer { objc_sync_exit(sharedInstance) }

        return ids.map {
            subscribers[$0]?.isSuspended = true
            return subscribers[$0]?.isSuspended ?? false
        }
    }

    static func resume(ids: ID...) -> [Bool] {
        return ids.map {
            subscribers[$0]?.isSuspended = false
            sharedInstance.runTask($0)
            return subscribers[$0]?.isSuspended == false
        }
    }
}

public extension Schedule {

    static func once(interval: NSTimeInterval, block: Void -> Void) -> ID {
        return dispatch(AnyGenerator(GeneratorOfOne(interval)), block: block)
    }

    static func timeout(interval: NSTimeInterval, block: Void -> Void) -> ID {
        return once(interval, block: block)
    }

    static func every(interval: NSTimeInterval, block: Void -> Void) -> ID {
        return dispatch(AnyGenerator { interval }, block: block)
    }

    static func after<C: CollectionType where C.Generator.Element == NSTimeInterval>(intervals: C, block: Void -> Void) -> ID {
        return dispatch(AnyGenerator(intervals.generate()), block: block)
    }

    static func countdown(interval: NSTimeInterval, times: UInt, block: (left: NSTimeInterval) -> Void) -> ID {
        var count = times + 1

        let intervals = AnyGenerator<NSTimeInterval> {
            switch count {
            case times + 1: count -= 1; return 0
            case 0: return nil
            default: count -= 1; return interval
            }
        }

        return dispatch(intervals) { block(left: Double(count) * interval) }
    }
}

private extension Schedule.Task {

    init(intervals: AnyGenerator<NSTimeInterval>, block: Void -> Void) {
        self.intervals = intervals
        self.block = block
    }
}