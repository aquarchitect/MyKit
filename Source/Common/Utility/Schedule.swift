//
//  Schedule.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/2/16.
//  
//

final public class Schedule {

    public typealias ID = UInt

    public enum Action { case Stop, Repeat }

    public struct Task {

        var interval: NSTimeInterval
        let block: Void -> Action
    }

    private static let sharedInstance = Schedule()
    private static var trackedID: ID = 0

    private(set) static var subscribers: [ID: Task] = [:]

    private func runTask(id: ID) {
        objc_sync_enter(Schedule.sharedInstance)
        defer { objc_sync_exit(Schedule.sharedInstance) }

        guard let task = Schedule.subscribers[id] else { return }

        switch task.block() {
        case .Stop:
            Schedule.subscribers.removeValueForKey(id)
        case .Repeat:
            Schedule.dispatch(id, interval: task.interval)
        }
    }
}

private extension Schedule {

    static func dispatch(interval: NSTimeInterval, block: Void -> Action) -> ID {
        assert(interval > 0, "Expecting time intervals to be greater than 0, not \(interval).")

        objc_sync_enter(sharedInstance)
        defer { objc_sync_exit(sharedInstance) }

        let id = trackedID

        subscribers[id] = Task(interval: interval, block: block)
        dispatch(id, interval: interval)

        trackedID += 1
        return id
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
}

public extension Schedule {

    public static func once(interval: NSTimeInterval, block: Void -> Void) -> ID {
        return dispatch(interval) { block(); return .Stop }
    }

    public static func every(interval: NSTimeInterval, block: Void -> Void) -> ID {
        return dispatch(interval) { block(); return .Repeat }
    }
}