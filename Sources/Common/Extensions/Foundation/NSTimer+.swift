/*
 * NSTimer+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import Foundation

#if swift(>=3.0)
#else
extension NSTimer {

    final class TimeIntervalObservable: Observable<NSTimeInterval> {

        private var count: UInt

        init(count: UInt) {
            self.count = count
        }

        @objc func handleTimer(timer: NSTimer) {
            guard count != 0 else { return timer.invalidate() }
            update(Double(count) * timer.timeInterval)
            count -= 1
        }
    }

    static func schedule(count count: UInt, timeInterval: NSTimeInterval) -> Observable<NSTimeInterval> {
        let observable = TimeIntervalObservable(count: count)

        NSTimer(timeInterval: timeInterval,
                target: observable,
                selector: #selector(TimeIntervalObservable.handleTimer),
                userInfo: nil,
                repeats: true)
            .then { NSRunLoop.currentRunLoop().addTimer($0, forMode: NSDefaultRunLoopMode) }

        return observable
    }
}

public extension NSTimer {

    static func countdown(count: UInt, timeInterval: NSTimeInterval) -> Observable<NSTimeInterval> {
        return schedule(count: count, timeInterval: timeInterval)
    }

    static func every(timeInterval: NSTimeInterval) -> Observable<NSTimeInterval> {
        return schedule(count: UInt.max, timeInterval: timeInterval)
    }
}
#endif
