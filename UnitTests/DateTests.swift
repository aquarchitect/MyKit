// 
// NSDateTests.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import XCTest

final class NSDateTests: XCTestCase {

    func testAddingUnitsToDate() {
        // April 15, 1452 - Leonardo Da Vinci's birthday
        let components = DateComponents(
            calendar: Date.calendar,
            timeZone: nil,
            era: nil, year: 1452,
            month: 4,
            day: 15,
            hour: nil,
            minute: nil,
            second: nil,
            nanosecond: nil,
            weekday: nil,
            weekdayOrdinal: nil,
            quarter: nil,
            weekOfMonth: nil,
            weekOfYear: nil,
            yearForWeekOfYear: nil
        )

        guard let date = components.date else { return XCTFail() }

        for (component, result) in [(.day, 16), (.month, 5), (.year, 1453)] as [(Calendar.Component, Int)] {
            XCTAssertEqual(date.adding(component, value: 1).value(of: component), result)
        }
    }
}
