//
//  NSDate+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/30/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public var Calendar: NSCalendar { return TimeSystem.sharedInstance.calendar }
public var Today: NSDate { return TimeSystem.sharedInstance.today }

public extension NSDate {

    public var components: NSDateComponents { return Calendar.components([.Year, .Month, .Day, .Weekday, .WeekOfMonth], fromDate: self) }

    public func firstDateOfTheMonth() -> NSDate {
        let components = Calendar.components([.Year, .Month], fromDate: self)
        return Calendar.dateFromComponents(components)!
    }

    public func firstDateOfTheWeek() -> NSDate {
        let components = Calendar.components([.Year, .WeekOfYear], fromDate: self)
        return Calendar.dateFromComponents(components)!
    }

    public func numberOfDaysInTheMonth() -> Int {
        return Calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: self).length
    }

    public func numberOfDaysInTheYear() -> Int {
        return Calendar.rangeOfUnit(.Day, inUnit: .Year, forDate: self).length
    }

    public func numberOfWeeksInTheMonth() -> Int {
        return Calendar.rangeOfUnit(.WeekOfMonth, inUnit: .Month, forDate: self).length
    }

    public func numberOfWeeksInTheYear() -> Int {
        return Calendar.rangeOfUnit(.WeekOfYear, inUnit: .Year, forDate: self).length
    }

    public func dateByAddingDays(value: Int) -> NSDate {
        return Calendar.dateByAddingUnit(.Day, value: value, toDate: self, options: NSCalendarOptions())!
    }

    public func dateByAddingWeeks(value: Int) -> NSDate {
        return Calendar.dateByAddingUnit(.Day, value: 7 * value, toDate: self, options: NSCalendarOptions())!
    }

    public func dateByAddingMonths(value: Int) -> NSDate {
        return Calendar.dateByAddingUnit(.Month, value: value, toDate: self, options: NSCalendarOptions())!
    }

    public func dateByAddingYears(value: Int) -> NSDate {
        return Calendar.dateByAddingUnit(.Year, value: value, toDate: self, options: NSCalendarOptions())!
    }

    public func isSameDayAsDate(date: NSDate) -> Bool {
        let components = Calendar.components([.Year, .Month, .Day], fromDate: date)
        return Calendar.date(self, matchesComponents: components)
    }

    public func isSameWeekAsDate(date: NSDate) -> Bool {
        let components = Calendar.components([.Year, .WeekOfYear], fromDate: date)
        return Calendar.date(self, matchesComponents: components)
    }

    public func isSameMonthAsDate(date: NSDate) -> Bool {
        let components = Calendar.components([.Year, .Month], fromDate: date)
        return Calendar.date(self, matchesComponents: components)
    }

    public func isToday() ->Bool {
        return isSameDayAsDate(Today)
    }

    public func isTomorrow() -> Bool {
        return isSameDayAsDate(Today.dateByAddingDays(1))
    }

    public func isYesterday() -> Bool {
        return isSameDayAsDate(Today.dateByAddingDays(-1))
    }

    public func isThisWeek() -> Bool {
        return isSameWeekAsDate(Today)
    }

    public func isNextWeek() -> Bool {
        return isSameWeekAsDate(Today.dateByAddingWeeks(1))
    }

    public func isLastWeek() -> Bool {
        return isSameWeekAsDate(Today.dateByAddingWeeks(-1))
    }

    public func isThisMonth() -> Bool {
        return isSameMonthAsDate(Today)
    }

    public func isNextMonth() -> Bool {
        return isSameMonthAsDate(Today.dateByAddingMonths(1))
    }

    public func isLastMonth() -> Bool {
        return isSameMonthAsDate(Today.dateByAddingMonths(-1))
    }

    public func isInFuture() -> Bool {
        return !isSameDayAsDate(Today) && self.compare(Today) == .OrderedAscending
    }

    public func isInPast() -> Bool {
        return !isSameDayAsDate(Today) && self.compare(Today) == .OrderedDescending
    }
}