/*
 * ReduxTests.swift
 * MyKit
 *
 * Created by Hai Nguyen on 12/7/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

@testable import MyKit

final class ReduxTests: XCTestCase {

    fileprivate enum Exception: Error { case a, b }

    fileprivate class SimpleRedux: Redux<String, Bool> {}

    fileprivate let reducer: SimpleRedux.Reducer = { state, action in
        let observable = Observable<String>()

        DispatchQueue.main.async {
            observable.update(action ? .fulfill(state) : .reject(Exception.a))
        }

        return observable
    }

    fileprivate let middleware1: SimpleRedux.Middleware = { state, dispatch in
        return { action in
            if action {
                throw Exception.b
            } else {
                try dispatch(action)
            }
        }
    }

    fileprivate let middleware2: SimpleRedux.Middleware = { state, dispatch in
        return { action in
            do {
                try dispatch(action)
            } catch {
                XCTAssertEqual(error as? Exception, action ? .b : .a)
            }
        }
    }
}

extension ReduxTests {

    func testMergingReducersWithSuccess() {
        let exepectation = self.expectation(description: #function)

        SimpleRedux.merge(reducer, reducer)("Initial", true).onNext {
            XCTAssertEqual($0, "Initial")
            exepectation.fulfill()
        }

        waitForExpectations(timeout: 2) { XCTAssertNil($0) }
    }

    func testMergingReducersWithFailure() {
        let exepectation = self.expectation(description: #function)

        SimpleRedux.merge(reducer, reducer)("Initial", false).onError {
            XCTAssertEqual($0 as? Exception, .a)
            exepectation.fulfill()
        }

        waitForExpectations(timeout: 2) { XCTAssertNil($0) }
    }
}

extension ReduxTests {

    func testMiddlewares() {
        let expectation = self.expectation(description: #function)

        do {
            let m = SimpleRedux.merge(middleware2, middleware1)
            try m("Initial", { _ in XCTFail("Should not execute this block") })(true)
            try m("Initial", { _ in expectation.fulfill() })(false)
        } catch {
            XCTFail(error.localizedDescription)
        }

        waitForExpectations(timeout: 2) { XCTAssertNil($0) }
    }
}

extension ReduxTests {

    func testBasicRedux() {
        let expectation = self.expectation(description: #function)

        let middleware: SimpleRedux.Middleware = { state, dispatch in
            return { action in expectation.fulfill() }
        }

        SimpleRedux(
            reducers: [reducer],
            middlewares: [middleware, middleware2, middleware1]
        ).dispatch("Initial", [true])

        waitForExpectations(timeout: 2) { XCTAssertNil($0) }
    }

    func testReduxCycles() {
        let expectation = self.expectation(description: #function)

        var count = 0
        let middleware: SimpleRedux.Middleware = { state, dispatch in
            return { action in
                count != 2 ? (count += 1) : expectation.fulfill()
            }
        }

        SimpleRedux(
            reducers: [reducer],
            middlewares: [middleware, middleware2, middleware1]
        ).dispatch("Initial", [true, true, true])

        waitForExpectations(timeout: 4) { XCTAssertNil($0) }
    }
}
