/*
 * NSTimer+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 10/18/16.
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

    func schedule(count: UInt, timeInterval: NSTimeInterval) -> Observable<NSTimeInterval> {
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
#endif
