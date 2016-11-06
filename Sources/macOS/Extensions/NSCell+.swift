/*
 * NSCell+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 11/2/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

import AppKit

public extension NSCell {

    #if swift(>=3.0)
    static var shared: NSCell {
        struct Singleton {
            static let value = NSCell().then {
                $0.wraps = true
            }
        }

        return Singleton.value
    }
    #else
    static func sharedInstance() -> UILabel {
        struct Singleton {
            static let value = UILabel().then {
                $0.numberOfLines = 0
            }
        }

        return Singleton.value
    }
    #endif
}
