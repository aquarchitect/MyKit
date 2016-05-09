//
//  Queueing.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

public struct Queue {

    public static var Main: dispatch_queue_t {
        return dispatch_get_main_queue()
    }

    public struct Global {

        public static var Utility: dispatch_queue_t {
            return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
        }

        public static var Background: dispatch_queue_t {
            return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        }

        public static var UserInitiated: dispatch_queue_t {
            return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        }

        public static var UserInteractive: dispatch_queue_t {
            return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
        }
    }
}