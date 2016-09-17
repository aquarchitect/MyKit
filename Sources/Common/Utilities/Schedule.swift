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

        private(set) var intervals: AnyGenerator<NSTimeInterval>

        public private(set) var isSuspended = false
        public private(set) var isCanceled = false

        let block: () -> Void
    }

    private static let sharedInstance = Schedule()
    private static var trackedID: ID = 0

    private(set) static var subscribers: [ID: Task] = [:]

    private func runTask(id: ID) {
        objc_sync_enter(Schedule.sharedInstance)
        defer { objc_sync_exit(Schedule.sharedInstance) }

        guard let task = Schedule.subscribers[id]
            where !task.isSuspended
            else { return }

        task.block()

        if let interval = task.intervals.next() {
            Schedule.dispatch(id, interval: interval)
        } else {
            Schedule.subscribers.removeValueForKey(id)
        }
    }
}

private extension Schedule {

    static func dispatch<G: GeneratorType where G.Element == NSTimeInterval>(intervals: G, block: () -> Void) -> ID {
        objc_sync_enter(sharedInstance)
        defer { objc_sync_exit(sharedInstance) }

        trackedID += 1 // fail-safe for canceling at 0

        let task = Task(intervals: intervals, block: block)
        subscribers[trackedID] = task

        if let interval = task.intervals.next() {
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

    static func cancel(id: ID) -> Task? {
        objc_sync_enter(sharedInstance)
        defer { objc_sync_exit(sharedInstance) }

        subscribers[id]?.isCanceled = true
        return subscribers.removeValueForKey(id)
    }

    static func suspend(id: ID) -> Task? {
        objc_sync_enter(sharedInstance)
        defer { objc_sync_exit(sharedInstance) }

        subscribers[id]?.isSuspended = true
        return subscribers[id]
    }

    static func resume(id: ID) -> Task? {
        subscribers[id]?.isSuspended = false
        sharedInstance.runTask(id)
        return subscribers[id]
    }
}

public extension Schedule {

    static func once(interval: NSTimeInterval, block: () -> Void) -> ID {
        return dispatch(GeneratorOfOne(interval), block: block)
    }

    static func timeout(interval: NSTimeInterval, block: () -> Void) -> ID {
        return once(interval, block: block)
    }

    static func every(interval: NSTimeInterval, block: () -> Void) -> ID {
        return dispatch(AnyGenerator { interval }, block: block)
    }

    static func after<C: CollectionType where C.Generator.Element == NSTimeInterval>(intervals: C, block: () -> Void) -> ID {
        return dispatch(intervals.generate(), block: block)
    }

    static func countdown(interval: NSTimeInterval, count: UInt, block: (left: NSTimeInterval) -> Void) -> ID {
        var _count = count + 1

        let intervals = AnyGenerator<NSTimeInterval> {
            switch _count {
            case count + 1: _count -= 1; return 0
            case 0: return nil
            default: _count -= 1; return interval
            }
        }

        return dispatch(intervals, block: { block(left: Double(_count) * interval) })
    }
}

private extension Schedule.Task {

    init<G: GeneratorType where G.Element == NSTimeInterval>(intervals: G, block: () -> Void) {
        self.intervals = AnyGenerator(intervals)
        self.block = block
    }

    /**
     * Warning: proceed with cautious of infinite sequence.
     */
    var timeRemaining: NSTimeInterval {
        return intervals.reduce(0, combine: +)
    }
}