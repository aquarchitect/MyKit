/*
 * PromiseTests.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

final class PromiseTests: XCTestCase {

//    func testFullfilledArray() {
//        let expectation = self.expectation(description: #function)
//
//        let ps = [Schedule.once(0.5).map { 5 },
//                  Schedule.once(0.5).map { 10 },
//                  Schedule.once(1.0).map { 15 }]
//
//        Promise<Int>.concat(ps).onSuccess {
//            XCTAssertEqual($0, [5, 10, 15])
//            expectation.fulfill()
//        }.onFailure {
//            XCTFail("Error \($0) Occurred")
//        }.resolve()
//
//        waitForExpectations(timeout: 3) {
//            XCTAssertNil($0)
//        }
//    }
//
//    func testRejectedArray() {
//        let expectation = self.expectation(description: #function)
//
//        let ps = [Schedule.once(0.5).map { 5 },
//                  Schedule.once(0.5).map { throw PromiseError.empty },
//                  Schedule.once(1.0).map { 15 }]
//
//        Promise<Int>.concat(ps).onSuccess {
//            XCTFail("Promise callback with value \($0)")
//        }.onFailure {
//            XCTAssertEqual($0 as? PromiseError, .empty)
//            expectation.fulfill()
//        }.resolve()
//
//        waitForExpectations(timeout: 3) {
//            XCTAssertNil($0)
//        }
//    }
//
//    func testFullfilledTuple() {
//        let expectation = self.expectation(description: #function)
//
//        let p1 = Schedule.once(0.5).map { true }
//        let p2 = Schedule.once(1.0).map { "Success" }
//
//        zip(p1, p2).onSuccess {
//            XCTAssert($0 && $1 == "Success")
//            expectation.fulfill()
//        }.onFailure {
//            XCTFail("Error \($0) Occurred")
//        }.resolve()
//
//        waitForExpectations(timeout: 3) {
//            XCTAssertNil($0)
//        }
//    }
//
//    func testRejectedTuple() {
//        let expectation = self.expectation(description: #function)
//
//        let p1 = Schedule.once(0.5).map { true }
//        let p2 = Schedule.once(1.0).map { throw PromiseError.empty }
//
//        zip(p1, p2).onSuccess {
//            XCTFail("Promise callback with value \($0)")
//        }.onFailure {
//            XCTAssertEqual($0 as? PromiseError, .empty)
//            expectation.fulfill()
//        }.resolve()
//
//        waitForExpectations(timeout: 3) {
//            XCTAssertNil($0)
//        }
//    }

    func testBackground() {
        let expectation = self.expectation(description: #function)

        Promise.lift { Thread.isMainThread }
            .inBackground()
            .onSuccess {
                XCTAssertFalse($0)
                expectation.fulfill()
            }.resolve()

        waitForExpectations(timeout: 3) {
            XCTAssertNil($0)
        }
    }
}
