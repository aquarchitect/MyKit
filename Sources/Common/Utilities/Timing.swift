//
//  Timing.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

import Foundation

/// Delays block execution on sepefic queue
public func delay(interval: NSTimeInterval, queue: dispatch_queue_t = Queue.Main, block: Void -> Void) {
    let poptime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * interval))
    dispatch_after(poptime, queue, block)
}

/// Measures and print execution elapsed time
public func measure(@noescape block: Void -> Void) {
    let start = CFAbsoluteTimeGetCurrent()
    block()
    let end = CFAbsoluteTimeGetCurrent()

    print("Elapsed time is \(end - start) seconds.")
}