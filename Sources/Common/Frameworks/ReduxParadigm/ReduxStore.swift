/*
 * ReduxStore.swift
 * MyKit
 *
 * Created by Hai Nguyen on 11/29/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

open class ReduxStore<State, Action> {

    public typealias Dispatch = (Action) throws -> Void
    public typealias Reducer = (State, Action) throws -> State
    public typealias Middleware = (ReduxStore, @escaping Dispatch) -> Dispatch

    public private(set) var state: State
    public private(set) var dispatch: Dispatch = { _ in }

    public init(reducer: @escaping Reducer, state: State) {
        self.state = state
        self.dispatch = { [weak self] action in
            guard let `self` = self else { return }
            self.state = try reducer(self.state, action)
        }
    }

    public func inject(_ middlewares: Middleware...) {
        dispatch = middlewares
            .reversed()
            .reduce(dispatch) { $1(self, $0) }
    }
}
