/*
 * NSDateTests.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

final class NSDateTests: XCTestCase {

    func testAddingUnitsToDate() {
        let components = DateComponents(calendar: Date.calendar,
                                        timeZone: nil,
                                        era: nil, year: 1990,
                                        month: 1,
                                        day: 23,
                                        hour: nil,
                                        minute: nil,
                                        second: nil,
                                        nanosecond: nil,
                                        weekday: nil,
                                        weekdayOrdinal: nil,
                                        quarter: nil,
                                        weekOfMonth: nil,
                                        weekOfYear: nil,
                                        yearForWeekOfYear: nil)

        guard let date = components.date else { return XCTFail() }

        for (component, result) in [(.day, 24), (.month, 2), (.year, 1991)] as [(Calendar.Component, Int)] {
            XCTAssertEqual(date.adding(component, value: 1).value(of: component), result)
        }
    }
}
