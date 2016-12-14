/*
 * Redux.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

/**
 * `Redux` takes a different approach from a typical Redux from web development.
 * The concepts are essentially the same - state of the entire application is 
 * dictated solely by actions.
 *
 * The key components that make this different are:
 * - The entire app state is encourage to be encapsulated inside a middleware. This
 *   approach provides a flexibility whether to save the state based on the current
 *   action.
 * - Actions are also encouraged to be recorded in a middleware - not only for debugging. 
 *   Best example to reason about it are selection attributes. These information are often
 *   redundantly reflect inside of the app array content, which also adds more responsibility
 *   into the object who maintains the state mutability of keeping both attributes in sync.
 * - State subscription is also encouraged to handle errors either catching from the root
 *   reducer or other middlewares. Most importantly, state subscription middleware needs to be
 *   positioned first in the queue.
 */
open class Redux<State, Action> {

    public typealias Reducer = (State, Action) -> Observable<State>
    public typealias Dispatcher = (Action) throws -> Void
    public typealias Middleware = (State, @escaping Dispatcher) -> Dispatcher

    public let input = Observable<(State, Action)>()

    public init(reducer: @escaping Reducer, middleware: @escaping Middleware) {
        input.flatMapLatest { state, action in
            reducer(state, action)
                .map { ($0, action) }
                .onError { error in
                    try? middleware(state, { _ in throw error })(action)
                }
        }.onNext { state, action in
            try? middleware(state, { _ in })(action)
        }
    }

    public convenience init(reducer: @escaping Reducer, middlewares: Middleware...) {
        self.init(reducer: reducer, middleware: Redux.merge(middlewares))
    }
}

extension Redux {

    static func merge(_ middlewares: [Middleware]) -> Middleware {
        return { state, dispatch in
            middlewares.reversed().reduce(dispatch, { $1(state, $0) })
        }
    }

    static func merge(_ middlerwares: Middleware...) -> Middleware {
        return merge(middlerwares)
    }
}
