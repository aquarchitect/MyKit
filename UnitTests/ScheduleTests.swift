//
//  ScheduleTests.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/5/16.
//  
//

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
        let id = Schedule.every(0.7) { count += 1 }

        delay(1.5) {
            exepectation.fulfill()
            XCTAssertEqual(Schedule.cancel(id), [true])
            XCTAssertEqual(count, 2)
        }

        waitForExpectationsWithTimeout(1.6) {
            XCTAssertNil($0)
            XCTAssertTrue(Schedule.subscribers.isEmpty)
        }
    }
}
