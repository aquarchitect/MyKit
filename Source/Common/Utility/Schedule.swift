//
//  Schedule.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/2/16.
//  
//

// FIXME: the class description

// because the way of the class structuring, the intervals generates not from one point of time, but an cumulative affect.

final public class Schedule {

    public typealias ID = UInt

    struct Task {

        var intervals: AnyGenerator<NSTimeInterval>

        var suspended = false
        let block: Void -> Void
    }

    private static let sharedInstance = Schedule()
    private static var trackedID: ID = 0

    private(set) static var subscribers: [ID: Task] = [:]

    private func runTask(id: ID) {
        objc_sync_enter(Schedule.sharedInstance)
        defer { objc_sync_exit(Schedule.sharedInstance) }

        guard let task = Schedule.subscribers[id] where !task.suspended else { return }
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

    public static func cancel(ids: ID...) -> [Bool] {
        objc_sync_enter(sharedInstance)
        defer { objc_sync_exit(sharedInstance) }

        return ids.map { subscribers.removeValueForKey($0) != nil }
    }

    public static func suspend(ids: ID...) -> [Bool] {
        objc_sync_enter(sharedInstance)
        defer { objc_sync_exit(sharedInstance) }

        return ids.map {
            subscribers[$0]?.suspended = true
            return subscribers[$0]?.suspended ?? false
        }
    }

    public static func resume(ids: ID...) -> [Bool] {
        return ids.map {
            subscribers[$0]?.suspended = false
            sharedInstance.runTask($0)
            return subscribers[$0]?.suspended == false
        }
    }
}

public extension Schedule {

    public static func once(interval: NSTimeInterval, block: Void -> Void) -> ID {
        return dispatch(AnyGenerator(GeneratorOfOne(interval)), block: block)
    }

    public static func timeout(interval: NSTimeInterval, block: Void -> Void) -> ID {
        return once(interval, block: block)
    }

    public static func every(interval: NSTimeInterval, block: Void -> Void) -> ID {
        return dispatch(AnyGenerator { interval }, block: block)
    }

    public static func after<C: CollectionType where C.Generator.Element == NSTimeInterval>(intervals: C, block: Void -> Void) -> ID {
        return dispatch(AnyGenerator(intervals.generate()), block: block)
    }

    public static func countdown(interval: NSTimeInterval, times: UInt, block: (left: NSTimeInterval) -> Void) -> ID {
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