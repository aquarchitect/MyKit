// 
// ReduxTests.swift
// MyKit
// 
// Created by Hai Nguyen on 12/7/16.
// Copyright (c) 2016 Hai Nguyen.
// 

@testable import MyKit

final class ReduxTests: XCTestCase {

    fileprivate enum Exception: Error { case a, b }

    fileprivate class SimpleRedux: Redux<String, Bool> {

        override init<S>(reducer: @escaping SimpleRedux.Reducer, middlewares: S) where
            S: Sequence,
            S.Iterator.Element == SimpleRedux.Middleware
        {
            super.init(reducer: reducer, middlewares: middlewares)
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

    func handle(_ state: String, _ action: Bool) -> Observable<String> {
        let result: Result<String> = action ? .fulfill(state) : .reject(Exception.a)
        return Observable.lift(try result.resolve())
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

    func testReduxDispatch() {
        let expectation = self.expectation(description: #function)

        let middleware3: SimpleRedux.Middleware = { state, dispatch in
            return { action in
                do {
                    try dispatch(action)
                    expectation.fulfill()
                } catch {
                    XCTFail()
                }
            }
        }

        SimpleRedux(
            reducer: handle(_:_:),
            middlewares: [middleware3, middleware2, middleware1]
        ).dispatch("Initial", true)

        waitForExpectations(timeout: 2) { XCTAssertNil($0) }
    }
}
