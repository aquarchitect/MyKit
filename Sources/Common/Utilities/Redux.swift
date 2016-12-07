/*
 * Redux.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

open class Redux<State, Action> {

    public typealias Reducer = (State, Action) -> Promise<State>

    public typealias Dispatcher = (Action) throws -> Void
    public typealias Middleware = (State, @escaping Dispatcher) -> Dispatcher

    final public private(set) var state: State

    final private let reducer: Reducer
    final private let middleware: Middleware

    public init(reducer: @escaping Reducer, state: State, middleware: @escaping Middleware) {
        self.state = state
        self.reducer = reducer
        self.middleware = middleware
    }

    /**
     * Errors from the reducer and other middlewares can be 
     * subscribed in a middleware placing first in the queue.
     */
    public convenience init(reducer: @escaping Reducer, state: State, middlewares: Middleware...) {
        self.init(reducer: reducer, state: state, middleware: Redux.merge(middlewares))
    }

    /**
     * If you override this method, make sure you call `super.dipstach`.
     */
    open func dispatch(_ action: Action) {
        reducer(state, action).resolve {
            var dispatch: Dispatcher = { _ in }

            switch $0 {
            case .fulfill(let state): self.state = state
            case .reject(let error): dispatch = { _ in throw error }
            }

            try? self.middleware(self.state, dispatch)(action)
        }
    }
}

public extension Redux {

    static func merge(_ middlewares: [Middleware]) -> Middleware {
        return { state, dispatch in
            middlewares
                .reversed()
                .reduce(
                    dispatch,
                    { $1(state, $0) }
                )
        }
    }

    static func merge(_ middlerwares: Middleware...) -> Middleware {
        return merge(middlerwares)
    }
}
