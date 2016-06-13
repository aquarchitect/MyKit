/*
 * ScheduleTests.swift
 * MyKit
 *
 * Copyright (c) 2015–2016 Hai Nguyen
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

@testable import MyKit

final class ScheduleTests: XCTestCase {

    func testScheduleOnce() {
        let expectation = expectationWithDescription(#function)
        Schedule.once(0.5) { expectation.fulfill() }

        waitForExpectationsWithTimeout(0.6) {
            XCTAssertNil($0)
            XCTAssertTrue(Schedule.subscribers.isEmpty)
        }
    }

    func testScheduleEvery() {
        let exepectation = expectationWithDescription(#function)

        var count = 0
        let id = Schedule.every(0.8) { count += 1 }

        delay(2) {
            exepectation.fulfill()
            XCTAssertEqual(Schedule.cancel(id), [true])
            XCTAssertEqual(count, 2)
        }

        waitForExpectationsWithTimeout(2.2) {
            XCTAssertNil($0)
            XCTAssertTrue(Schedule.subscribers.isEmpty)
        }
    }
}