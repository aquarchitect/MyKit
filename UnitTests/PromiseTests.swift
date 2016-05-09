//
//  PromiseTests.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/8/16.
//  
//

infix operator +++ { associativity left }

final class PromiseTests: XCTestCase {

    private func delayFor<T>(interval: CFTimeInterval, result: Result<T>) -> Promise<T> {
        return Promise { callback in delay(interval) { callback(result) }}
    }

    func testFullfilledArray() {
        let expectation = expectationWithDescription(#function)

        let ps = [(0.5, .Fullfill(5)), (0.5, .Fullfill(10)), (1.0, .Fullfill(15))].map(delayFor)

        Promise<Int>.when(ps).resolve {
            switch $0 {

            case .Fullfill(let value):
                XCTAssertEqual(value, [5, 10, 15])
                expectation.fulfill()

            case .Reject(let error):
                XCTFail("Error \(error) Occurred")
            }
        }

        waitForExpectationsWithTimeout(3) { XCTAssertNil($0) }
    }

    func testRejectedArray() {
        let expectation = expectationWithDescription(#function)

        let ps = [(0.5, .Fullfill(5)), (0.5, .Reject(CommonError.NoDataContent)), (1.0, .Fullfill(15))].map(delayFor)

        Promise<Int>.when(ps).resolve {
            switch $0 {

            case .Fullfill(let value):
                XCTFail("Promise callback with value \(value)")

            case .Reject(CommonError.NoDataContent):
                XCTAssert(true)
                expectation.fulfill()

            case .Reject(let error):
                XCTFail("Error \(error) Occurred")
            }
        }

        waitForExpectationsWithTimeout(3) { XCTAssertNil($0) }
    }

    func testFullfilledTuple() {
        let expectation = expectationWithDescription(#function)

        let p1 = delayFor(0.5, result: .Fullfill(true))
        let p2 = delayFor(1.0, result: .Fullfill("Success"))

        (p1 +++ p2).resolve {
            switch $0 {

            case .Fullfill(let value):
                XCTAssert(value.0 && value.1 == "Success")
                expectation.fulfill()

            case .Reject(let error):
                XCTFail("Error \(error) Occurred")
            }
        }

        waitForExpectationsWithTimeout(3) { XCTAssertNil($0) }
    }

    func testRejectedTuple() {
        let expectation = expectationWithDescription(#function)

        let p1 = delayFor(0.5, result: .Fullfill(true))
        let p2 = delayFor(1.0, result: Result<String>.Reject(CommonError.NoDataContent))

        (p1 +++ p2).resolve {
            switch $0 {

            case .Fullfill(let value):
                XCTFail("Promise callback with value \(value)")

            case .Reject(CommonError.NoDataContent):
                XCTAssert(true)
                expectation.fulfill()

            case .Reject(let error):
                XCTFail("Error \(error) Occurred")
            }
        }

        waitForExpectationsWithTimeout(3) { XCTAssertNil($0) }
    }
}
