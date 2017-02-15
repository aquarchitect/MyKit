/*
 * Redux.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import Foundation

/**
 * The implementation of `Redux` takes a very different approach from a typical 
 * unidirectional architecture flow from web development. The concept is essentially
 * the same which is to encapsulate the application STATE mutation process with
 * ACTIONs.
 *
 * The key different components are:
 * - MIDDLEWARE plays a significant role in this implementation such as action recorder,
 *   state subscription, app store (state storage)...
 * - The implementation is kept fundamentally very simple. STATE is not stored in
 *   this object but rather in an independent MIDDLEWARE.
 * - All of throwing errors from REDUCERs can be caught on the first MIDDLEWARE
 *   of the queue.
 */
open class Redux<State, Action> {

    public typealias Reducer = (State, Action) throws -> State
    public typealias Dispatcher = (Action) throws -> Void
    public typealias Middleware = (State, @escaping Dispatcher) -> Dispatcher

    private let reducer: Reducer
    private let middleware: Middleware

    public init(reducer: @escaping Reducer, middlewares: [Middleware]) {
        self.reducer = reducer
        self.middleware = Redux.merge(middlewares)
    }

    public func dispatch(state: State, action: Action) {
        let newState: State
        let firstDispatch: Dispatcher

        do {
            newState = try reducer(state, action)
            firstDispatch = { _ in }
        } catch {
            newState = state
            firstDispatch = { _ in throw error }
        }

        try? middleware(newState, firstDispatch)(action)
    }
}

public extension Redux {

    static func merge(_ middlewares: [Middleware]) -> Middleware {
        return { state, dispatch in
            middlewares.reversed().reduce(dispatch, { $1(state, $0) })
        }
    }

    static func merge(_ middlerwares: Middleware...) -> Middleware {
        return merge(middlerwares)
    }
}
