/*
 * Date+.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

// MARK: Support Method

public extension Date {

    typealias Period = (passed: Int, left: Int)

    static var today: Date {
        return Date().startOfDay()
    }

    static var calendar: Calendar {
        return .autoupdatingCurrent
    }

    func startOfDay() -> Date {
        return Date.calendar.startOfDay(for: self)
    }

    func value(of component: Calendar.Component) -> Int {
        return Date.calendar.component(component, from: self)
    }

    func dateComponents(_ components: [Calendar.Component]) -> DateComponents {
        return Date.calendar.dateComponents(Set(components), from: self)
    }

    func adding(_ component: Calendar.Component, value: Int) -> Date {
        return Date.calendar.date(byAdding: component, value: value, to: self)!
    }

    func range(of smallerComponent: Calendar.Component, in largerComponent: Calendar.Component) -> Range<Int> {
        return Date.calendar.range(of: smallerComponent, in: largerComponent, for: self)!
    }

    func isMatched(with components: DateComponents) -> Bool {
        return Date.calendar.date(self, matchesComponents: components)
    }
}

// MARK: First Date

public extension Date {

    func firstDateOfTheMonth() -> Date {
        return Date.calendar.date(from: dateComponents([.year, .month]))!
    }

    func firstDateOfTheWeek() -> Date {
        return Date.calendar.date(from: dateComponents([.year, .weekOfYear]))!
    }
}

// MARK: Number of Days

public extension Date {

    func numberOfDaysInTheMonth() -> Int {
        return range(of: .day, in: .month).count
    }

    func numberOfDaysInTheYear() -> Int {
        return range(of: .day, in: .year).count
    }

    func numberOfWeeksInTheMonth() -> Int {
        return range(of: .weekOfMonth, in: .month).count
    }

    func numberOfWeeksInTheYear() -> Int {
        return range(of: .weekOfYear, in: .year).count
    }

    static func numberOfDaysInThisWeek() -> Period {
        var days = calendar.firstWeekday - today.dateComponents([.weekday]).weekday!
        days += 7 * Int(.init(value: days <= 0))
        return (7 - days, days - 1)
    }

    static func numberOfDaysInThisMonth() -> Period {
        let days = today.range(of: .day, in: .month).count
        let day = today.value(of: .day)
        return (day - 1, days - day)
    }

    static func numberOfWeeksInThisMonth() -> Period {
        let weeks = today.range(of: .weekOfMonth, in: .month).count
        let week = today.value(of: .weekOfMonth)
        return (week - 1, weeks - week)
    }

    static func numebrOfDaysInThisMonth() -> Period {
        let days = today.range(of: .day, in: .month).count
        let day = today.value(of: .day)
        return (day - 1, days - day)
    }
}

// MARK: Date Calculation

public extension Date {

    func adding(days value: Int) -> Date {
        return adding(.day, value: value)
    }

    func adding(weeks value: Int) -> Date {
        return adding(.day, value: 7 * value)
    }

    func adding(months value: Int) -> Date {
        return adding(.month, value: value)
    }

    func adding(years value: Int) -> Date {
        return adding(.year, value: value)
    }
}

// MARK: Date Comparison

public extension Date {

    func isSameDayAs(_ date: Date) -> Bool {
        return (date.dateComponents >>> isMatched)([.year, .month, .day])
    }

    func isSameWeekAs(_ date: Date) -> Bool {
        return (date.dateComponents >>> isMatched)([.year, .weekOfYear])
    }

    func isSameMonthAs(_ date: Date) -> Bool {
        return (date.dateComponents >>> isMatched)([.year, .month])
    }

    func isSameYearAs(_ date: Date) -> Bool {
        return (date.dateComponents >>> isMatched)([.year])
    }
}

// MARK: today Comparison

public extension Date {

    func isInFuture() -> Bool {
        return !isSameDayAs(Date.today) && self.compare(Date.today) == .orderedDescending
    }

    func isInPast() -> Bool {
        return !isSameDayAs(Date.today) && self.compare(Date.today) == .orderedAscending
    }
}

// MARK: today Comparison within a Week

public extension Date {

    func istoday() ->Bool {
        return isSameDayAs(.today)
    }

    func isTomorrow() -> Bool {
        return (Date.today.adding(days:) >>> isSameDayAs)(1)
    }

    func isYesterday() -> Bool {
        return (Date.today.adding(days:) >>> isSameDayAs)(-1)
    }
}

// MARK: today Comparison within a Month

public extension Date {

    func isThisWeek() -> Bool {
        return isSameWeekAs(.today)
    }

    func isNextWeek() -> Bool {
        return (Date.today.adding(weeks:) >>> isSameWeekAs)(1)
    }

    func isLastWeek() -> Bool {
        return (Date.today.adding(weeks:) >>> isSameWeekAs)(-1)
    }
}

// MARK: today Comparison within a Year

public extension Date {

    func isThisMonth() -> Bool {
        return isSameMonthAs(.today)
    }

    func isNextMonth() -> Bool {
        return (Date.today.adding(months:) >>> isSameMonthAs)(1)
    }

    func isLastMonth() -> Bool {
        return (Date.today.adding(months:) >>> isSameMonthAs)(-1)
    }
}

public extension Date {

    func isThisYear() -> Bool {
        return isSameYearAs(.today)
    }

    func isNextYear() -> Bool {
        return (Date.today.adding(years:) >>> isSameYearAs)(-1)
    }

    func isLastYear() -> Bool {
        return (Date.today.adding(years:) >>> isSameYearAs)(-1)
    }
}

// MARK: String with Style

public extension Date {

    private func string(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        return DateFormatter.shared.then {
                $0.timeStyle = timeStyle
                $0.dateStyle = dateStyle
            }.andThen {
                $0.string(from: self)
            }
    }

    func string(with style: DateFormatter.Style) -> String {
        return string(dateStyle: style, timeStyle: style)
    }

    func timeString(with style: DateFormatter.Style) -> String {
        return string(dateStyle: .none, timeStyle: style)
    }

    func dateString(with style: DateFormatter.Style) -> String {
        return string(dateStyle: style, timeStyle: .none)
    }
}
