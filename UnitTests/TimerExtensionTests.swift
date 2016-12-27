/*
 * TimerExtensionTests.swift
 * MyKit
 *
 * Created by Hai Nguyen on 12/26/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

@testable import MyKit

final class TimerExtensionTests: XCTestCase {}

extension TimerExtensionTests {

    func testCountdown() {
        let expectation = self.expectation(description: #function)
        var iterator = stride(from: 2.0, through: 0, by: -0.5).makeIterator()

        Timer.countdown(5, timeInterval: 0.5).onNext {
            XCTAssertEqual(iterator.next(), $0)
            $0 != 0 ? () : expectation.fulfill()
        }

        waitForExpectations(timeout: 4) { XCTAssertNil($0) }
    }

    func testEvery() {
        // TODO: implement stop singal by another signal in order to break out infinitive loop.
    }
}
