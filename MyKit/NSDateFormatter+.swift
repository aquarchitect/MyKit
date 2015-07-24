//
//  NSDateFormatter+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public let Formatter = NSDateFormatter()

public extension NSDateFormatter {

    public static func stringFromDate(date: NSDate, format: String) -> String {
        Formatter.dateFormat = format
        return Formatter.stringFromDate(date)
    }
}