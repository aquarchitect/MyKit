//
//  NSDate+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/30/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension NSDate {

    private var calendar: NSCalendar { return TimeSystem.sharedInstance.calendar }
    private var today: NSDate { return TimeSystem.sharedInstance.today }

    public func components(unit: NSCalendarUnit) -> NSDateComponents {
        return calendar.components(unit, fromDate: self)
    }

    public func components(unit: NSCalendarUnit, toDate date: NSDate) -> NSDateComponents {
        return calendar.components(unit, fromDate: self, toDate: date, options: [])
    }

    public func dateByAddingUnit(unit: NSCalendarUnit, value: Int) -> NSDate {
        return calendar.dateByAddingUnit(unit, value: value, toDate: self, options: [])!
    }

    public func firstDateOfTheMonth() -> NSDate {
        return calendar.dateFromComponents(components([.Year, .Month]))!
    }

    public func firstDateOfTheWeek() -> NSDate {
        return calendar.dateFromComponents(components([.Year, .WeekOfYear]))!
    }

    public func numberOfDaysInTheMonth() -> Int {
        return calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: self).length
    }

    public func numberOfDaysInTheYear() -> Int {
        return calendar.rangeOfUnit(.Day, inUnit: .Year, forDate: self).length
    }

    public func numberOfWeeksInTheMonth() -> Int {
        return calendar.rangeOfUnit(.WeekOfMonth, inUnit: .Month, forDate: self).length
    }

    public func numberOfWeeksInTheYear() -> Int {
        return calendar.rangeOfUnit(.WeekOfYear, inUnit: .Year, forDate: self).length
    }

    public func dateByAddingDays(value: Int) -> NSDate {
        return dateByAddingUnit(.Day, value: value)
    }

    public func dateByAddingWeeks(value: Int) -> NSDate {
        return dateByAddingUnit(.Day, value: 7 * value)
    }

    public func dateByAddingMonths(value: Int) -> NSDate {
        return dateByAddingUnit(.Month, value: value)
    }

    public func dateByAddingYears(value: Int) -> NSDate {
        return dateByAddingUnit(.Year, value: value)
    }

    public func isSameDayAsDate(date: NSDate) -> Bool {
        return calendar.date(self, matchesComponents: date.components([.Year, .Month, .Day]))
    }

    public func isSameWeekAsDate(date: NSDate) -> Bool {
        return calendar.date(self, matchesComponents: date.components([.Year, .WeekOfYear]))
    }

    public func isSameMonthAsDate(date: NSDate) -> Bool {
        return calendar.date(self, matchesComponents: date.components([.Year, .Month]))
    }

    public func isSameYearAsDate(date: NSDate) -> Bool {
        return calendar.date(self, matchesComponents: date.components(.Year))
    }

    public func isToday() ->Bool {
        return isSameDayAsDate(today)
    }

    public func isTomorrow() -> Bool {
        return isSameDayAsDate(today.dateByAddingDays(1))
    }

    public func isYesterday() -> Bool {
        return isSameDayAsDate(today.dateByAddingDays(-1))
    }

    public func isThisWeek() -> Bool {
        return isSameWeekAsDate(today)
    }

    public func isNextWeek() -> Bool {
        return isSameWeekAsDate(today.dateByAddingWeeks(1))
    }

    public func isLastWeek() -> Bool {
        return isSameWeekAsDate(today.dateByAddingWeeks(-1))
    }

    public func isThisMonth() -> Bool {
        return isSameMonthAsDate(today)
    }

    public func isNextMonth() -> Bool {
        return isSameMonthAsDate(today.dateByAddingMonths(1))
    }

    public func isLastMonth() -> Bool {
        return isSameMonthAsDate(today.dateByAddingMonths(-1))
    }

    public func isThisYear() -> Bool {
        return isSameYearAsDate(today)
    }

    public func isLastYear() -> Bool {
        return isSameYearAsDate(today.dateByAddingYears(-1))
    }

    public func isNextYear() -> Bool {
        return isSameYearAsDate(today.dateByAddingYears(1))
    }

    public func isInFuture() -> Bool {
        return !isSameDayAsDate(today) && self.compare(today) == .OrderedDescending
    }

    public func isInPast() -> Bool {
        return !isSameDayAsDate(today) && self.compare(today) == .OrderedAscending
    }
}