/*
 * ScheduleTests.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

@testable import MyKit

final class ScheduleTests: XCTestCase {

    private enum Exception: Error { case cancelled }

    func testOnce() {
        let expectation = self.expectation(description: #function)

        Schedule.once(0.5)
            .onSuccess { expectation.fulfill() }
            .resolve()

        waitForExpectations(timeout: 0.6) { XCTAssertNil($0) }
    }

    func testSuccessfulCountdown() {
        let expectation = self.expectation(description: #function)
        var iterator = stride(from: 2.5, through: 0, by: -0.5).makeIterator()

        Schedule.countdown(0.5, count: 5) {
            XCTAssertEqual(iterator.next(), $0)
        }.onSuccess {
            expectation.fulfill()
        }.resolve()

        waitForExpectations(timeout: 4) {
            XCTAssertNil($0)
        }
    }

    func testFailureCountdown() {
        let expectation = self.expectation(description: #function)
        var iterator = stride(from: 4, through: 0, by: -0.5).makeIterator()

        Schedule.countdown(0.5, count: 8) {
            XCTAssertEqual(iterator.next(), $0)
            if $0 < 2 { throw Exception.cancelled }
        }.onFailure {
            XCTAssertEqual($0 as? Exception, .cancelled)
            expectation.fulfill()
        }.resolve()

        waitForExpectations(timeout: 5) {
            XCTAssertNil($0)
        }
    }

    func testEvery() {
        let expectation = self.expectation(description: #function)
        var iterator = stride(from: 0, through: 4, by: 0.5).makeIterator()

        Schedule.every(0.5) {
            XCTAssertEqual(iterator.next(), $0)
            if $0 < 2 { throw Exception.cancelled }
        }.onFailure {
            XCTAssertEqual($0 as? Exception, .cancelled)
            expectation.fulfill()
        }.resolve()

        waitForExpectations(timeout: 4) {
            XCTAssertNil($0)
        }
    }
}
