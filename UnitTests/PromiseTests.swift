/*
 * PromiseTests.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

infix operator +++ { associativity left }

final class PromiseTests: XCTestCase {

    private enum Error: ErrorType { case Failed }

    private func delayFor<T>(interval: CFTimeInterval, result: Result<T>) -> Promise<T> {
        return Promise { callback in delay(interval) { callback(result) }}
    }

    func testFullfilledArray() {
        let expectation = expectationWithDescription(#function)

        let ps = [(0.5, .fullfill(5)),
                  (0.5, .fullfill(10)),
                  (1.0, .fullfill(15))]
                    .map(delayFor)

        Promise<Int>.when(ps).resolve {
            switch $0 {
            case .fullfill(let value):
                XCTAssertEqual(value, [5, 10, 15])
                expectation.fulfill()
            case .reject(let error):
                XCTFail("Error \(error) Occurred")
            }
        }


        waitForExpectationsWithTimeout(3) { XCTAssertNil($0) }
    }

    func testRejectedArray() {
        let expectation = expectationWithDescription(#function)

        let ps = [(0.5, .fullfill(5)),
                  (0.5, .reject(Error.Failed)),
                  (1.0, .fullfill(15))]
                    .map(delayFor)

        Promise<Int>.when(ps).resolve {
            switch $0 {
            case .fullfill(let value):
                XCTFail("Promise callback with value \(value)")
            case .reject(Error.Failed):
                XCTAssert(true)
                expectation.fulfill()
            case .reject(let error):
                XCTFail("Error \(error) Occurred")
            }
        }

        waitForExpectationsWithTimeout(3) { XCTAssertNil($0) }
    }

    func testFullfilledTuple() {
        let expectation = expectationWithDescription(#function)

        let p1 = delayFor(0.5, result: .fullfill(true))
        let p2 = delayFor(1.0, result: .fullfill("Success"))

        (p1 +++ p2).resolve {
            switch $0 {
            case .fullfill(let value):
                XCTAssert(value.0 && value.1 == "Success")
                expectation.fulfill()
            case .reject(let error):
                XCTFail("Error \(error) Occurred")
            }
        }

        waitForExpectationsWithTimeout(3) { XCTAssertNil($0) }
    }

    func testRejectedTuple() {
        let expectation = expectationWithDescription(#function)

        let p1 = delayFor(0.5, result: .fullfill(true))
        let p2 = delayFor(1.0, result: Result<String>.reject(Error.Failed))

        (p1 +++ p2).resolve {
            switch $0 {
            case .fullfill(let value):
                XCTFail("Promise callback with value \(value)")
            case .reject(Error.Failed):
                XCTAssert(true)
                expectation.fulfill()
            case .reject(let error):
                XCTFail("Error \(error) Occurred")
            }
        }

        waitForExpectationsWithTimeout(3) { XCTAssertNil($0) }
    }
}
