//
//  TimeSystem.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/30/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public class TimeSystem {

    public typealias Period = (passed: Int, left: Int)
    public static let sharedInstance = TimeSystem()

    public private(set) lazy var today: NSDate = {
        return self.calendar.startOfDayForDate(NSDate())
    }()

    public var calendar: NSCalendar { return .currentCalendar() }

    public func numberOfDaysInThisWeek() -> Period {
        var days = calendar.firstWeekday - today.components(.Weekday).weekday
        days += 7 * Int(days <= 0)
        return (7 - days, days - 1)
    }

    public func numberOfDaysInThisMonth() -> Period {
        let days = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: today).length
        let day = today.components(.Day).day
        return (day - 1, days - day)
    }

    public func numberOfWeeksInThisMonth() -> Period {
        let weeks = calendar.rangeOfUnit(.WeekOfMonth, inUnit: .Month, forDate: today).length
        let week = today.components(.WeekOfMonth).weekOfMonth
        return (week - 1, weeks - week)
    }

    public func numebrOfDaysInThisMonth() -> Period {
        let days = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: today).length
        let day = today.components(.Day).day
        return (day - 1, days - day)
    }
}