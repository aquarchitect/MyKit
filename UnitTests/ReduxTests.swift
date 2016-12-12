/*
 * ReduxTests.swift
 * MyKit
 *
 * Created by Hai Nguyen on 12/7/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

final class ReduxTests: XCTestCase {

    enum Exception: Error { case a, b }

    fileprivate class Store: Redux {

        typealias State = String
        typealias Action = Bool

        let middleware: Store.Middleware

        let reducer: Store.Reducer = { state, action in
            switch action {
            case true: return Promise.lift { state }
            case false: return Promise.lift { throw Exception.a }
            }
        }

        init(middlewares: Store.Middleware...) {
            self.middleware = Store.merge(middlewares)
        }

        func dispatch(_ action: Bool) {
            dispatch("Initial", action)
        }
    }

    func testMiddlewares() {


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

        let store = Store(middlewares: m2, m1)
        store.dispatch(true)
        store.dispatch(false)
    }
}
