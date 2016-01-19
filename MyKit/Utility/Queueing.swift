//
//  Queueing.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

/// Simplified dispatch queue constant.
public struct Queue {

    /// Main queue
    public static var Main: dispatch_queue_t {
        return dispatch_get_main_queue()
    }

    public struct Global {

        /// Global utility queue.
        public static var Utility: dispatch_queue_t {
            return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
        }

        /// Global background queue.
        public static var Background: dispatch_queue_t {
            return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        }

        /// Global user intitiated queue.
        public static var UserInitiated: dispatch_queue_t {
            return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        }

        /// Globale user user interactive queue.
        public static var UserInteractive: dispatch_queue_t {
            return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
        }
    }
}