/*
 * NSDateTests.swift
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
