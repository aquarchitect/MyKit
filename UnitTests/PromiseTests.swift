//
// PromiseTests.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
//

import MyKit

final class PromiseTests: XCTestCase {

    func testFullfilledArray() {
        let expectation = self.expectation(description: #function)

        let ps = [5, 10, 15].map(Promise.init)

        Promise<Int>.concat(ps).onSuccess {
            XCTAssertEqual($0, [5, 10, 15])
            expectation.fulfill()
        }.onFailure {
            XCTFail("Error \($0) Occurred")
        }.resolve()

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testRejectedArray() {
        let expectation = self.expectation(description: #function)

        let ps = [
            Promise(5),
            Promise<Int>(MyKit.Error.harmless),
            Promise(10)
        ]

        Promise<Int>.concat(ps).onSuccess {
            XCTFail("Promise callback with value \($0)")
        }.onFailure {
            XCTAssertEqual($0 as? MyKit.Error, .harmless)
            expectation.fulfill()
        }.resolve()

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testFullfilledTuple() {
        let expectation = self.expectation(description: #function)

        let p1 = Promise(true)
        let p2 = Promise("Success")

        zip(p1, p2).onSuccess {
            XCTAssert($0 && $1 == "Success")
            expectation.fulfill()
        }.onFailure {
            XCTFail("Error \($0) Occurred")
        }.resolve()

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testRejectedTuple() {
        let expectation = self.expectation(description: #function)

        let p1 = Promise(true)
        let p2 = Promise<String>(MyKit.Error.harmless)

        zip(p1, p2).onSuccess {
            XCTFail("Promise callback with value \($0)")
        }.onFailure {
            XCTAssertEqual($0 as? MyKit.Error, .harmless)
            expectation.fulfill()
        }.resolve()

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testBackground() {
        let expectation = self.expectation(description: #function)

        Promise("Dummy")
            .inBackground()
            .onSuccess { _ in
                XCTAssertFalse(Thread.isMainThread)
                expectation.fulfill()
            }.resolve()

        waitForExpectations(timeout: 3, handler: nil)
    }
}
