/*
 * Redux.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

open class Redux<State, Action> {

    public typealias Dispatch = (Action) -> Action
    public typealias Reducer = (Action, State) -> State
    public typealias Middleware = (Redux, Dispatch) -> Dispatch

    open fileprivate(set) var state: State
    public fileprivate(set) var dispatch: Dispatch = { $0 }

    public init(reducer: @escaping Reducer, state: State) {
        self.state = state
        self.dispatch = { [weak self] in
            guard let `self` = self else { return $0 }
            self.state = reducer($0, self.state)
            return $0
        }
    }

    public func inject(_ middlewares: Middleware...) {
        dispatch = middlewares.reduce(dispatch) { $1(self, $0) }
    }
}

public extension Redux {

    static func logger(store: Redux, yield: @escaping Dispatch) -> Dispatch {
        return {
            let action = yield($0)
            print(action, store.state)
            return action
        }
    }
}
