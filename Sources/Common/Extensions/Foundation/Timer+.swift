/*
 * Timer+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 10/14/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

import Foundation

#if swift(>=3.0)
extension Timer {

    final class TimeIntervalObservable: Observable<TimeInterval> {

        private var count: UInt

        init(count: UInt) {
            self.count = count
        }

        @objc func handleTimer(timer: Timer) {
            guard count != 0 else { return timer.invalidate() }
            update(Double(count) * timer.timeInterval)
            count -= 1
        }
    }

    func schedule(count: UInt, timeInterval: TimeInterval) -> Observable<TimeInterval> {
        let observable = TimeIntervalObservable(count: count)

        Timer(timeInterval: timeInterval,
              target: observable,
              selector: #selector(TimeIntervalObservable.handleTimer(timer:)),
              userInfo: nil,
              repeats: true)
            .then { RunLoop.current.add($0, forMode: .defaultRunLoopMode) }

        return observable
    }
}

public extension Timer {

    func countdown(_ count: UInt, timerInterval: TimeInterval) -> Observable<TimeInterval> {
        return schedule(count: count, timeInterval: timerInterval)
    }

    func every(_ timerInterval: TimeInterval) -> Observable<TimeInterval> {
        return schedule(count: UInt.max, timeInterval: timerInterval)
    }
}
#else
#endif
