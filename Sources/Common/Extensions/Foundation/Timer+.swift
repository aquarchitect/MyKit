/*
 * Timer+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 10/14/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

import Foundation

public extension Timer {

    @available(iOS 10.0, macOS 10.12, *)
    static func countdown(_ count: UInt, timeInterval: TimeInterval) -> Observable<TimeInterval> {
        let observable = Observable<TimeInterval>()
        var _count = count

        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak observable] in
            guard let _signal = observable else { return $0.invalidate() }
            guard _count != 0 else { return $0.invalidate() }

            _signal.update(Double(_count) * timeInterval)
            _count -= 1
        }

        return observable
    }

    @available(iOS 10.0, macOS 10.12, *)
    static func every(timeInterval: TimeInterval) -> Observable<TimeInterval> {
        let observable = Observable<TimeInterval>()
        var _count = 0

        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak observable] in
            guard let _signal = observable else { return $0.invalidate() }

            _signal.update(Double(_count) * timeInterval)
            _count += 1
        }

        return observable
    }
}
