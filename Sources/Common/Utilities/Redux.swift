// 
// Redux.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import Foundation

/// `Redux` is a redeign of `_Redux`. The implemetation integrates
/// the use of `Observable` to `REDUCER, which allows to dispatch
/// state and action with `flatMap` latest. 
/// 
/// - Note: In the previous implemetation, `ActionReducer` holds
/// a significant responsibility such as traversing actions stack
/// for a specific actions (selected index), which creates quite 
/// a complexity for a new signal coming in.
open class Redux<State, Action> {

    public typealias Reducer = (State, Action) -> Observable<State>
    public typealias Dispatcher = (Action) throws -> Void
    public typealias Middleware = (State, @escaping Dispatcher) -> Dispatcher

    // MARK: Properties

    private let inputStream = Observable<(State, Action)>()

    // MARK: Initialization

    public init(reducer: @escaping Reducer, middleware: @escaping Middleware) {
        // error is directed to handle in one of the middlewaress.
        _ = inputStream.flatMap { oldState, action in
            reducer(oldState, action).onError { error in
                try? middleware(oldState, { _ in throw error })(action)
            }.onNext { newState in
                try? middleware(newState, { _ in })(action)
            }
        }
    }

    public convenience init<S>(reducer: @escaping Reducer, middlewares: S) where
        S: Sequence,
        S.Iterator.Element == Middleware
    {
        self.init(reducer: reducer, middleware: Redux.merge(middlewares))
    }

    // MARK: Support Methods

    open func dispatch(_ state: State, _ action: Action) {
        inputStream.update((state, action))
    }
}

public extension Redux {

    static func merge<S>(_ middlewares: S) -> Middleware where
        S: Sequence,
        S.Iterator.Element == Middleware
    {
        return { state, dispatch in
            middlewares
                .reversed()
                .reduce(dispatch, { $1(state, $0) })
        }
    }

    static func merge(_ middlerwares: Middleware...) -> Middleware {
        return merge(middlerwares)
    }
}
