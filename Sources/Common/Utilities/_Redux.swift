//
// _Redux.swift
// MyKit
//
// Created by Hai Nguyen on 4/30/17.
// Copyright (c) 2017 Hai Nguyen.
//

import Foundation

/// `_Redux` implements the unidirectional arachitecture flow that takes a different
/// approach from web development. The core concept is essentially the same - encapsulating
/// the application STATE mutation with systematic ACTIONs.
///
/// The key components are:
/// - MIDDLEWAREs play much more significant roles in the flow such as: 
///     * Action Recorder - stack user actions for later potential analysis.
///     * State Subscription - update UI components appropriately.  
///     * App Store - store current application state.
/// - The implementation is kept fundamentally simple. STATE is not stored in
///   this object but rather in one of the independent MIDDLEWAREs.
/// - Errors from both REDUCER and MIDDLEWARE can be caught by one of the MIDDEWAREs
///   that is positioned first in the queue.
@available(*, deprecated)
open class _Redux<State, Action> {

    public typealias Reducer = (State, Action) throws -> State
    public typealias Dispatcher = (Action) throws -> Void
    public typealias Middleware = (State, @escaping Dispatcher) -> Dispatcher

    // MARK: Properties

    private let reducer: Reducer
    private let middleware: Middleware

    // MARK: Initialization

    public init<S>(reducer: @escaping Reducer, middlewares: S) where
        S: Sequence,
        S.Iterator.Element == Middleware
    {
        self.reducer = reducer
        self.middleware = _Redux.merge(middlewares)
    }

    // MARK: Helper Methods

    /// This is designed specifically for unit testing. One action can finish a cycle
    /// (reducer + middlewares) after another.
    ///
    /// - Parameters:
    ///   - state: initial state
    ///   - cycles: cycles of action
    ///   - completion: invoke when cycles are empty
    final func dispatch<I>(_ state: State, _ cycles: inout I, _ completion: (() -> Void)?) where
        I: IteratorProtocol,
        I.Element == Action
    {
        guard let action = cycles.next() else {
            completion?(); return
        }

        let newState: State
        let firstDispatch: Dispatcher
        let isContinued: Bool

        do {
            newState = try reducer(state, action)
            firstDispatch = { _ in }
            isContinued = true
        } catch {
            newState = state
            firstDispatch = { _ in throw error }
            isContinued = false
        }

        try? middleware(newState, firstDispatch)(action)

        // continue next cycles
        if isContinued { dispatch(newState, &cycles, completion) }
    }

    open func dispatch<S>(_ state: State, _ cycles: S, _ completion: (() -> Void)?) where
        S: Sequence,
        S.Iterator.Element == Action
    {
        var iterator = cycles.makeIterator()
        dispatch(state, &iterator, completion)
    }

    open func dispatch(_ state: State, _ action: Action) {
        dispatch(state, [action], nil)
    }
}

@available(*, deprecated)
public extension _Redux {

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
