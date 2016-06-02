//
//  Queueing.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

import Foundation

public struct Queue {

    public struct Global {}
}

public extension Queue {

    static var Main: dispatch_queue_t {
        return dispatch_get_main_queue()
    }
}

public extension Queue.Global {

    static var Utility: dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
    }

    static var Background: dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    }

    static var UserInitiated: dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
    }

    static var UserInteractive: dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
    }
}