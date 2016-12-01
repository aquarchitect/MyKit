/*
 * Redux.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

open class Redux<State, Action> {

    public typealias Dispatch = (Action) throws -> Void
    public typealias Reducer = (State, Action) throws -> State
    public typealias Middleware = (Redux, @escaping Dispatch) -> Dispatch

    public private(set) var state: State
    fileprivate(set) var _dispatch: Dispatch = { _ in }

    public init(reducer: @escaping Reducer, state: State) {
        self.state = state
        self._dispatch = { [weak self] action in
            guard let `self` = self else { return }
            self.state = try reducer(self.state, action)
        }
    }

    public func inject(_ middlewares: Middleware...) {
        _dispatch = middlewares
            .reversed()
            .reduce(_dispatch) { $1(self, $0) }
    }

    open func dispatch(_ action: Action) throws {
        try _dispatch(action)
    }
}
