/*
 * SignalTests.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

@testable import MyKit

final class SignalTests: XCTestCase {

    private let result = "Hello World"
    private let observable = Observable<String>()

    func testSimpleSignal() {
        let expectation = self.expectation(description: #function)

        observable.map {
            $0 + " World"
        }.onNext {
            expectation.fulfill()
            XCTAssertEqual($0, self.result)
        }

        observable.update("Hello")

        waitForExpectations(timeout: 2) {
            XCTAssertNil($0)
        }
    }

    func testDelaySignal() {
        let expectation = self.expectation(description: #function)

        observable.map {
            $0 + " World"
        }.delay(4).onNext {
            expectation.fulfill()
            XCTAssertEqual($0, self.result)
        }

        observable.update("Hello")

        waitForExpectations(timeout: 6) {
            XCTAssertNil($0)
        }
    }
}
