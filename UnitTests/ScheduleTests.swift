/*
 * ScheduleTests.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

@testable import MyKit

final class ScheduleTests: XCTestCase {

    private enum Exception: Error { case interupted }

    func testScheduleOnce() {
        let expectation = self.expectation(description: #function)
        Schedule.once(0.5)
            .onSuccess { expectation.fulfill() }
            .resolve()

        waitForExpectations(timeout: 0.6) { XCTAssertNil($0) }
    }

    func testScheduleEvery() {
        let expectation = self.expectation(description: #function)
        var count = 0

        Schedule.every(0.8, handle: { _ in
            if count < 5 {
                count += 1
            } else {
                throw Exception.interupted
            }
        }).resolve()


        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 7) {
            XCTAssertNil($0)
        }
    }
}
