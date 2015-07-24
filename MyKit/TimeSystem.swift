//
//  TimeSystem.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/30/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public class TimeSystem {

    public typealias Period = (past: Int, future: Int)
    public static let sharedInstance = TimeSystem()

    let calendar = NSCalendar.currentCalendar()
    private(set) var today: NSDate!

    public private(set) var thisWeekDays: Period!
    public private(set) var thisMonthWeeks: Period!

    private init() {
        resetToday()
        resetFirstWeekday(1)
    }

    public func resetToday() {
        today = calendar.startOfDayForDate(NSDate())
    }

    public func resetFirstWeekday(weekday: Int) {
        let range = NSMakeRange(1, 7)
        let condition = NSLocationInRange(weekday, range)
        assert(condition, "Weekday is out of range")

        calendar.firstWeekday = weekday

        var days = weekday - calendar.component(.Weekday, fromDate: today)
        days += 7 * Int(days <= 0)
        thisWeekDays = (7 - days, days - 1)

        let count = calendar.rangeOfUnit(.WeekOfMonth, inUnit: .Month, forDate: today).length
        let week = calendar.component(.WeekOfMonth, fromDate: today)
        thisMonthWeeks = (week - 1, count - week)
    }
}