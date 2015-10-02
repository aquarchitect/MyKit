//
//  NSDateFormatter+.swift
//  MyKit
//
//  Created by Hai Nguyen on 10/1/15.
//
//

public extension NSDateFormatter {

    public static func stringFromDate(date: NSDate, format: String) -> String {
        struct Cache { static let formatter = NSDateFormatter() }
        Cache.formatter.dateFormat = format
        return Cache.formatter.stringFromDate(date)
    }
}
