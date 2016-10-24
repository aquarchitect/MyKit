/*
 * Timing.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen
 */

import Foundation

#if swift(>=3.0)
#else
public func delay(timeInterval: NSTimeInterval, block: () -> Void) {
    let poptime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * timeInterval))
    dispatch_after(poptime, Queue.Main, block)
}
#endif
