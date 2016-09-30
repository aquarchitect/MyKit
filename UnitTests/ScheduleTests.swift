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

    func testOnce() {
        let expectation = self.expectation(description: #function)

        Schedule.once(0.5)
            .onSuccess { expectation.fulfill() }
            .resolve()

        waitForExpectations(timeout: 0.6) { XCTAssertNil($0) }
    }

    func testSuccessfulCountdown() {
        let expectation = self.expectation(description: #function)

        Schedule.countdown(0.5, count: 5, handle: { _ in }).then {
            XCTAssertTrue(true)
            expectation.fulfill()
        }.resolve()

        waitForExpectations(timeout: 3) { XCTAssertNil($0) }
    }

    func testFailureCountdown() {
        let expectation = self.expectation(description: #function)

        Schedule.countdown(0.5, count: 5, handle: {
            guard $0 < 1 else { return }
            throw Exception.interupted
        }).onFailure { _ in
            XCTAssertTrue(true)
            expectation.fulfill()
        }.resolve()

        waitForExpectations(timeout: 3) { XCTAssertNil($0) }
    }

    func testEvery() {
        let expectation = self.expectation(description: #function)
        Schedule.every(0.8, handle: {
            guard $0 > 5 else { return }
            throw Exception.interupted
        }).onFailure { _ in
            expectation.fulfill()
        }.resolve()

        waitForExpectations(timeout: 7) {
            XCTAssertNil($0)
        }
    }
}
