// 
// Timer+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import Foundation

public extension Timer {

    class func every(_ timeInterval: TimeInterval, block: @escaping (Timer) -> Void) -> Timer {
        return CFRunLoopTimerCreateWithHandler(
            kCFAllocatorDefault,
            CFAbsoluteTimeGetCurrent() + timeInterval,
            timeInterval, 0, 0,
            { $0.flatMap({ block($0 as Timer) }) }
        )
    }

    class func countdown(_ timeInterval: TimeInterval, from count: UInt, block: @escaping (UInt, Timer) -> Void) -> Timer {
        var _count = count

        let timer = every(timeInterval) {
            if _count == 0 {
                $0.invalidate()
            } else {
                _count -= 1
                block(_count, $0)
            }
        }

        defer { block(_count, timer) }
        return timer
    }
}
