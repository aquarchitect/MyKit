//
//  NSDate+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/30/15.
//  
//

public extension NSDate {

    public typealias Period = (passed: Int, left: Int)

    public static var Today: NSDate {
        return NSDate().startOfDay()
    }

    public var calendar: NSCalendar {
        return .autoupdatingCurrentCalendar()
    }

    public func startOfDay() -> NSDate {
        return calendar.startOfDayForDate(self)
    }

    public func components(unit: NSCalendarUnit) -> NSDateComponents {
        return calendar.components(unit, fromDate: self)
    }

    public func dateByAdding(unit: NSCalendarUnit, value: Int) -> NSDate {
        return calendar.dateByAddingUnit(unit, value: value, toDate: self, options: [])!
    }

    public func rangeOfUnit(smallerUnit: NSCalendarUnit, inUnit largerUnit: NSCalendarUnit) -> NSRange {
        return calendar.rangeOfUnit(smallerUnit, inUnit: largerUnit, forDate: self)
    }

    public func isMatchedWith(components: NSDateComponents) -> Bool {
        return calendar.date(self, matchesComponents: components)
    }
}

// MARK: First Date

public extension NSDate {

    public func firstDateOfTheMonth() -> NSDate {
        return calendar.dateFromComponents(components([.Year, .Month]))!
    }

    public func firstDateOfTheWeek() -> NSDate {
        return calendar.dateFromComponents(components([.Year, .WeekOfYear]))!
    }
}

// MARK: Number of Days

public extension NSDate {

    public func numberOfDaysInTheMonth() -> Int {
        return rangeOfUnit(.Day, inUnit: .Month).length
    }

    public func numberOfDaysInTheYear() -> Int {
        return rangeOfUnit(.Day, inUnit: .Year).length
    }

    public func numberOfWeeksInTheMonth() -> Int {
        return rangeOfUnit(.WeekOfMonth, inUnit: .Month).length
    }

    public func numberOfWeeksInTheYear() -> Int {
        return rangeOfUnit(.WeekOfYear, inUnit: .Year).length
    }

    public func numberOfDaysInThisWeek() -> Period {
        var days = calendar.firstWeekday - NSDate.Today.components(.Weekday).weekday
        days += 7 * Int(days <= 0)
        return (7 - days, days - 1)
    }

    public func numberOfDaysInThisMonth() -> Period {
        let days = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: .Today).length
        let day = NSDate.Today.components(.Day).day
        return (day - 1, days - day)
    }

    public func numberOfWeeksInThisMonth() -> Period {
        let weeks = calendar.rangeOfUnit(.WeekOfMonth, inUnit: .Month, forDate: .Today).length
        let week = NSDate.Today.components(.WeekOfMonth).weekOfMonth
        return (week - 1, weeks - week)
    }

    public func numebrOfDaysInThisMonth() -> Period {
        let days = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: .Today).length
        let day = NSDate.Today.components(.Day).day
        return (day - 1, days - day)
    }
}

// MARK: Date Calculation

public extension NSDate {

    public func dateByAdding(days value: Int) -> NSDate {
        return dateByAdding(.Day, value: value)
    }

    public func dateByAdding(weeks value: Int) -> NSDate {
        return dateByAdding(.Day, value: 7 * value)
    }

    public func dateByAdding(months value: Int) -> NSDate {
        return dateByAdding(.Month, value: value)
    }

    public func dateByAdding(years value: Int) -> NSDate {
        return dateByAdding(.Year, value: value)
    }
}

// MARK: Date Comparison

public extension NSDate {

    public func isSameDayAs(date: NSDate) -> Bool {
        return date.components([.Year, .Month, .Day]).then(isMatchedWith)
    }

    public func isSameWeekAs(date: NSDate) -> Bool {
        return date.components([.Year, .WeekOfYear]).then(isMatchedWith)
    }

    public func isSameMonthAs(date: NSDate) -> Bool {
        return date.components([.Year, .Month]).then(isMatchedWith)
    }

    public func isSameYearAs(date: NSDate) -> Bool {
        return date.components(.Year).then(isMatchedWith)
    }
}

// MARK: Today Comparison

public extension NSDate {

    public func isInFuture() -> Bool {
        return NSDate.Today.then { !isSameDayAs($0) && self.compare($0) == .OrderedDescending }
    }

    public func isInPast() -> Bool {
        return NSDate.Today.then { !isSameDayAs($0) && self.compare($0) == .OrderedAscending }
    }
}

// MARK: Today Comparison within a Week

public extension NSDate {

    public func isToday() ->Bool {
        return isSameDayAs(.Today)
    }

    public func isTomorrow() -> Bool {
        return NSDate.Today.dateByAdding(days: 1).then(isSameDayAs)
    }

    public func isYesterday() -> Bool {
        return NSDate.Today.dateByAdding(days: -1).then(isSameDayAs)
    }
}

// MARK: Today Comparison within a Month

public extension NSDate {

    public func isThisWeek() -> Bool {
        return isSameWeekAs(.Today)
    }

    public func isNextWeek() -> Bool {
        return NSDate.Today.dateByAdding(weeks: 1).then(isSameWeekAs)
    }

    public func isLastWeek() -> Bool {
        return NSDate.Today.dateByAdding(weeks: -1).then(isSameWeekAs)
    }
}

// MARK: Today Comparison within a Year

public extension NSDate {

    public func isThisMonth() -> Bool {
        return isSameMonthAs(.Today)
    }

    public func isNextMonth() -> Bool {
        return NSDate.Today.dateByAdding(months: 1).then(isSameMonthAs)
    }

    public func isLastMonth() -> Bool {
        return NSDate.Today.dateByAdding(months: -1).then(isSameMonthAs)
    }

    public func isThisYear() -> Bool {
        return isSameYearAs(.Today)
    }

    public func isLastYear() -> Bool {
        return NSDate.Today.dateByAdding(years: -1).then(isSameYearAs)
    }

    public func isNextYear() -> Bool {
        return NSDate.Today.dateByAdding(years: 1).then(isSameYearAs)
    }
}

// MARK: String with Style

public extension NSDate {

    public func stringWith(date date: NSDateFormatterStyle, time: NSDateFormatterStyle) -> String {
        let formatter = NSDateFormatter.sharedInstance
        formatter.timeStyle = time
        formatter.dateStyle = date
        return formatter.stringFromDate(self)
    }

    public func stringWith(style: NSDateFormatterStyle) -> String {
        return stringWith(date: style, time: style)
    }

    public func timeStringWith(style: NSDateFormatterStyle) -> String {
        return stringWith(date: .NoStyle, time: style)
    }

    public func dateStringWithStyle(style: NSDateFormatterStyle) -> String {
        return stringWith(date: style, time: .NoStyle)
    }
}