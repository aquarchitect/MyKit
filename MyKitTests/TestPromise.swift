//
//  TestPromise.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/8/16.
//  
//

infix operator +++ { associativity left }

final class TestPromise: XCTestCase {

    func testFullfilledArray() {
        let expectation = expectationWithDescription("Callback after delay")

        let p1 = Promise<Int> { callback in delay(0.5) { callback(.Fullfill(5)) }}
        let p2 = Promise<Int> { callback in delay(0.5) { callback(.Fullfill(10)) }}
        let p3 = Promise<Int> { callback in delay(1.0) { callback(.Fullfill(15)) }}

        Promise<Int>.when([p1, p2, p3]).resolve {
            switch $0 {

            case .Fullfill(let value):
                XCTAssertEqual(value, [5, 10, 15])
                expectation.fulfill()

            case .Reject(let error):
                XCTFail("Error \(error) Occurred")
            }
        }

        waitForExpectationsWithTimeout(3) {
            XCTAssertNil($0, "Error \($0!) Occurred")
        }
    }

    func testRejectedArray() {
        let expectation = expectationWithDescription("Callback after delay")

        let p1 = Promise<Int> { callback in delay(0.5) { callback(.Fullfill(5)) }}
        let p2 = Promise<Int> { callback in delay(0.5) { callback(.Reject(DataError.NoContent)) }}
        let p3 = Promise<Int> { callback in delay(1.0) { callback(.Fullfill(15)) }}

        Promise<Int>.when([p1, p2, p3]).resolve {
            switch $0 {

            case .Fullfill(let value):
                XCTFail("Promise callback with value \(value)")

            case .Reject(DataError.NoContent):
                XCTAssert(true)
                expectation.fulfill()

            case .Reject(let error):
                XCTFail("Error \(error) Occurred")
            }
        }

        waitForExpectationsWithTimeout(3) {
            XCTAssertNil($0, "Error \($0!) Occurred")
        }
    }

    func testFullfilledTuple() {
        let expectation = expectationWithDescription("Callback after delay")

        let p1 = Promise<Bool> { callback in delay(0.5) { callback(.Fullfill(true)) }}
        let p2 = Promise<String> { callback in delay(1) { callback(.Fullfill("Success")) }}

        (p1 +++ p2).resolve {
            switch $0 {

            case .Fullfill(let value):
                XCTAssert(value.0 && value.1 == "Success")
                expectation.fulfill()

            case .Reject(let error):
                XCTFail("Error \(error) Occurred")
            }
        }

        waitForExpectationsWithTimeout(3) {
            XCTAssertNil($0, "Error \($0!) Occurred")
        }
    }

    func testRejectedTuple() {
        let expectation = expectationWithDescription("Callback after delay")

        let p1 = Promise<Bool> { callback in delay(0.5) { callback(.Fullfill(true)) }}
        let p2 = Promise<String> { callback in delay(1) { callback(.Reject(DataError.NoContent)) }}

        (p1 +++ p2).resolve {
            switch $0 {

            case .Fullfill(let value):
                XCTFail("Promise callback with value \(value)")

            case .Reject(DataError.NoContent):
                XCTAssert(true)
                expectation.fulfill()

            case .Reject(let error):
                XCTFail("Error \(error) Occurred")
            }
        }

        waitForExpectationsWithTimeout(3) {
            XCTAssertNil($0, "Error \($0!) Occurred")
        }
    }
}
