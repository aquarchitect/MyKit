//
//  TimeSystem.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/30/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public class TimeSystem {

    public static let sharedInstance = TimeSystem(calendar: .currentCalendar())

    public let calendar: NSCalendar
    public private(set) var today: NSDate

    private init(calendar: NSCalendar) {
        self.calendar = calendar
        self.today = calendar.startOfDayForDate(NSDate())
    }

    public func numberOfDaysInThisWeek() -> (Int, Int) {
        var days = calendar.firstWeekday - today.components([.Weekday]).weekday
        days += 7 * Int(days <= 0)
        return (7 - days, days - 1)
    }

    public func numberOfWeeksInThisMonth() -> (Int, Int) {
        let weeks = calendar.rangeOfUnit(.WeekOfMonth, inUnit: .Month, forDate: today).length
        let week = today.components([.WeekOfMonth]).weekOfMonth
        return (week - 1, weeks - week)
    }
}