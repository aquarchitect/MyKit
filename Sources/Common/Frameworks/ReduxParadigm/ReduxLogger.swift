/*
 * ReduxLogger.swift
 * MyKit
 *
 * Created by Hai Nguyen on 11/29/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

open class ReduxLogger<Action> {

    public fileprivate(set) var actions: [Action] = []

    public init() {}
}

public extension ReduxLogger {

    typealias Store<State> = ReduxStore<State, Action>

    func makeMiddleware<State>() -> Store<State>.Middleware {
        return { store, dispatch in
            return { action in
                self.actions.append(action)
                print(action, store.state)
                try dispatch(action)
            }
        }
    }
}
