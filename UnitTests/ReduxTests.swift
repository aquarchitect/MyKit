/*
 * ReduxTests.swift
 * MyKit
 *
 * Created by Hai Nguyen on 12/7/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

@testable import MyKit

final class ReduxTests: XCTestCase {

    enum Exception: Error { case a, b }

    fileprivate class Store: Redux<String, Bool> {

        init(middlewares: Store.Middleware...) {
            let reducer: Store.Reducer = { state, action in
                let observable = Observable<String>()

                switch action {
                case true: observable.update(state)
                case false: observable.update(Exception.a)
                }

                return observable
            }

            super.init(reducer: reducer, middleware: Store.merge(middlewares))
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
        store.input.update(("Initial", true))
        store.input.update(("Initial", false))
    }
}
