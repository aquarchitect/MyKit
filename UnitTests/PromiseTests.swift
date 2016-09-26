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

final class PromiseTests: XCTestCase {

    private enum Exception: Error { case failed }

    private func delay<T>(dt: TimeInterval, result: Result<T>) -> Promise<T> {
        return Promise { callback in
            DispatchQueue.main.asyncAfter(deadline: .now() + dt) {
                callback(result)
            }
        }
    }

    func testFullfilledArray() {
        let expectation = self.expectation(description: #function)

        let ps = [(0.5, .fullfill(5)),
                  (0.5, .fullfill(10)),
                  (1.0, .fullfill(15))]
            .map(delay)

        Promise<Int>.when(ps).resolve {
            switch $0 {
            case .fullfill(let value):
                XCTAssertEqual(value, [5, 10, 15])
                expectation.fulfill()
            case .reject(let error):
                XCTFail("Error \(error) Occurred")
            }
        }

        waitForExpectations(timeout: 3) { XCTAssertNil($0) }
    }

    func testRejectedArray() {
        let expectation = self.expectation(description: #function)

        let ps = [(0.5, .fullfill(5)),
                  (0.5, .reject(Exception.failed)),
                  (1.0, .fullfill(15))]
                    .map(delay)

        Promise<Int>.when(ps).resolve {
            switch $0 {
            case .fullfill(let value):
                XCTFail("Promise callback with value \(value)")
            case .reject(Exception.failed):
                XCTAssert(true)
                expectation.fulfill()
            case .reject(let error):
                XCTFail("Error \(error) Occurred")
            }
        }

        waitForExpectations(timeout: 3) { XCTAssertNil($0) }
    }

    func testFullfilledTuple() {
        let expectation = self.expectation(description: #function)

        let p1 = delay(dt: 0.5, result: .fullfill(true))
        let p2 = delay(dt: 1.0, result: .fullfill("Success"))

        when(p1, p2).resolve {
            switch $0 {
            case .fullfill(let value):
                XCTAssert(value.0 && value.1 == "Success")
                expectation.fulfill()
            case .reject(let error):
                XCTFail("Error \(error) Occurred")
            }
        }

        waitForExpectations(timeout: 3) { XCTAssertNil($0) }
    }

    func testRejectedTuple() {
        let expectation = self.expectation(description: #function)

        let p1 = delay(dt: 0.5, result: .fullfill(true))
        let p2 = delay(dt: 1.0, result: Result<String>.reject(Exception.failed))

        when(p1, p2).resolve {
            switch $0 {
            case .fullfill(let value):
                XCTFail("Promise callback with value \(value)")
            case .reject(Exception.failed):
                XCTAssert(true)
                expectation.fulfill()
            case .reject(let error):
                XCTFail("Error \(error) Occurred")
            }
        }

        waitForExpectations(timeout: 3) { XCTAssertNil($0) }
    }
}
