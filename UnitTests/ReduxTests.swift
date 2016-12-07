/*
 * ReduxTests.swift
 * MyKit
 *
 * Created by Hai Nguyen on 12/7/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

final class ReduxTests: XCTestCase {

    private typealias Store = Redux<String, Bool>

    func testMiddlewares() {
        enum Exception: Error { case a, b }

        let reducer: Store.Reducer = { state, action in
            switch action {
            case true: return Promise.lift { state }
            case false: return Promise.lift { throw Exception.a }
            }
        }

        let m1: Store.Middleware = { state, dispatch in
            return { action in
                switch action {
                case true: throw Exception.b
                case false: try dispatch(action)
                }

                XCTFail("This block is not supposed to be executed")
            }
        }

        let m2: Store.Middleware = { state, dispatch in
            return { action in
                do {
                    try dispatch(action)
                    XCTFail("This block is supposed to fail")
                } catch {
                    switch action {
                    case true: XCTAssertTrue(error as? Exception == .b)
                    case false: XCTAssertTrue(error as? Exception == .a)
                    }
                }
            }
        }

        let store = Store(reducer: reducer, state: "Initial", middleware: Store.merge(m2, m1))

        store.dispatch(true)
        store.dispatch(false)
    }
}
