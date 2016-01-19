//
//  Timing.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

/// Delays block execution
public func delay(time: NSTimeInterval, block: Void -> Void) {
    let poptime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * time))
    dispatch_after(poptime, Queue.Main, block)
}

/// Measures and output execution elapsed time
public func time(action: Void -> Void) {
    let start = CFAbsoluteTimeGetCurrent()
    action()
    let end = CFAbsoluteTimeGetCurrent()

    print("Elapsed time is \(end - start) seconds.")
}
