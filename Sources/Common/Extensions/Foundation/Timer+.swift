/*
 * Timer+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import Foundation

extension Timer {

    final private class Counter {

        var count: UInt
        let observable = Observable<TimeInterval>()

        init(startAt count: UInt) {
            self.count = count
        }

        @objc func handleTimer(timer: Timer) {
            guard count != 0 else { return timer.invalidate() }
            count -= 1
            observable.update(Double(count) * timer.timeInterval)
        }
    }

    static func schedule(count: UInt, timeInterval: TimeInterval) -> Observable<TimeInterval> {
        let counter = Counter(startAt: count)

        Timer(timeInterval: timeInterval,
              target: counter,
              selector: #selector(Counter.handleTimer(timer:)),
              userInfo: nil,
              repeats: true)
            .then { RunLoop.current.add($0, forMode: .defaultRunLoopMode) }

        return counter.observable
    }
}

public extension Timer {

    static func countdown(_ count: UInt, timeInterval: TimeInterval) -> Observable<TimeInterval> {
        return schedule(count: count, timeInterval: timeInterval)
    }

    static func every(_ timeInterval: TimeInterval) -> Observable<TimeInterval> {
        return schedule(count: UInt.max, timeInterval: timeInterval)
    }
}
