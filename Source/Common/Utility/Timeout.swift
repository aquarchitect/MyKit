//
//  Timeout.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/2/16.
//  
//

public class Timeout {

    private let id: Schedule.ID

    public init(after: NSTimeInterval, block: Void -> Void) {
        self.id = Schedule.once(after, block: block)
    }

    deinit { cancel() }

    public func cancel() {
        Schedule.cancel(id)
    }
}