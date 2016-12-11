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

    // MARK: Properties

    final public private(set) var state: State

    final private let reducer: Reducer
    final private let middleware: Middleware

    // MARK: Initialization

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

    // MARK: Primary Methods

    /**
     * If you override this method, make sure you call `super.dipstach`.
     */
    open func dispatch(_ action: Action) {
        reducer(state, action).resolve { [weak self] result in
            guard let `self` = self else { return }
            let dispatch: Dispatcher = { _ in
                self.state = try result.resolve()
            }

            let state = (try? result.resolve()) ?? self.state
            try? self.middleware(state, dispatch)(action)
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
