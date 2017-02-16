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
        if action {
            return state
        } else {
            throw Exception.a
        }
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

        SimpleRedux(
            reducer: reducer,
            middlewares: [middleware2, middleware1]
        ).dispatch("Initial", [true]) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2) { XCTAssertNil($0) }
    }

    func testReduxCycles() {
        let expectation = self.expectation(description: #function)

        SimpleRedux(
            reducer: reducer,
            middlewares: [middleware2, middleware1]
        ).dispatch("Initial", [true, true, true]) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 4) { XCTAssertNil($0) }
    }
}
