/*
 * Redux.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

/**
 * `Redux` protocol takes a different approach than the known Redux architecture
 * from web development. The concept is basically the same - state of the entire
 * application is dictated solely by actions. 
 *
 * The key components different from typical Redux are:
 * - State is not stored in the main component, but instead should be encapsulated
 *   in a middleware.
 * - Actions are encourage to be recorded (not just for debugging purposes). Best
 *   example to reasoning about it is selected index. State object often has an
 *   attribute dedicated for this, which also relected in the array of content.
 *   This is unneccessarily redundant; beside in the same object, whatever the
 *   controller is in charge of maintaining the state mutability has another
 *   responsibility which is to keep both of selecting attributes in sync.
 *
 */
public protocol Redux: class {

    associatedtype State
    associatedtype Action

    typealias Reducer = (State, Action) -> Promise<State>
    typealias Dispatcher = (Action) throws -> Void
    typealias Middleware = (State, @escaping Dispatcher) -> Dispatcher

    var reducer: Reducer { get }
    var middleware: Middleware { get }

    func dispatch(_ action: Action)
}

public extension Redux {

    func dispatch(_ state: State, _ action: Action) {
        reducer(state, action)
            .onSuccess { state in
                try? self.middleware(state, { _ in })(action)
            }.onFailure { error in
                try? self.middleware(state, { _ in throw error })(action)
            }.resolve()
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
