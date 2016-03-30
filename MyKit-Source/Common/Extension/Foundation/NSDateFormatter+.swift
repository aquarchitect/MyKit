//
//  NSDateFormatter+.swift
//  MyKit
//
//  Created by Hai Nguyen on 10/1/15.
//
//

public extension NSDateFormatter {

    public static var sharedInstance: NSDateFormatter {
        struct Cache { static let formatter = NSDateFormatter() }
        return Cache.formatter
    }

    public func stringFromDateWithFormat(date: NSDate, format: String) -> String {
        self.dateFormat = format
        return self.stringFromDate(date)
    }

    public func dateFromStringWithFormat(string: String, format: String) -> NSDate? {
        self.dateFormat = format
        return self.dateFromString(string)
    }
}
