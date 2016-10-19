/*
 * NSDateFormatter+.swift
 * MyKit
 *
 * Created by Hai Nguyen
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

#if swift(>=3.0)
#else
public extension NSDateFormatter {

    public static func sharedInstance() -> NSDateFormatter {
        struct Singleton {
            static let value = NSDateFormatter()
        }

        return Singleton.value
    }
}

public extension NSDateFormatter {

    public func string(from date: NSDate, format: String) -> String {
        self.dateFormat = format
        return self.stringFromDate(date)
    }

    public func date(from string: String, format: String) -> NSDate? {
        self.dateFormat = format
        return self.dateFromString(string)
    }
}
#endif
