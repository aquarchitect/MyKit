/*
 * Redux.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import Foundation

/**
 * The implementation of `Redux` takes a very different approach from a typical 
 * unidirectional architecture flow from web development. The concept is essentially
 * the same which is to encapsulate the application STATE mutation process with
 * ACTIONs.
 *
 * The key different components are:
 * - MIDDLEWARE plays a significant role in this implementation such as action recorder,
 *   state subscription, app store (state storage)...
 * - The implementation is kept fundamentally very simple. STATE is not stored in
 *   this object but rather in an independent MIDDLEWARE.
 * - All of potential errors are directed to be handled in one of the middlewares.
 *   By positioning it first in the queue, state subscription not only catches
 *   errors from reducers but also from other middlewares.
 */
open class Redux<State, Action> {

    public typealias Reducer = (State, Action) throws -> State
    public typealias Dispatcher = (Action) throws -> Void
    public typealias Middleware = (State, @escaping Dispatcher) -> Dispatcher

    // MARK: Properties

    private let reducer: Reducer
    private let middleware: Middleware

    // one cycle = reducers + middlewares
    private var cycles = AnyIterator<(TimeInterval, Action)>(EmptyIterator())

    // MARK: Initialization

    public init(reducer: @escaping Reducer, middlewares: [Middleware]) {
        self.reducer = reducer
        self.middleware = Redux.merge(middlewares)
    }

    // MARK: Helper Methods

    private func dispatch(_ state: State, _ action: Action) {
        let newState: State
        let firstDispatch: Dispatcher
        let updateCycle: ((State) -> Void)?

        do {
            newState = try reducer(state, action)
            firstDispatch = { _ in }
            updateCycle = updateNextCycle
        } catch {
            newState = state
            firstDispatch = { _ in throw error }
            updateCycle = nil
        }

        try? middleware(newState, firstDispatch)(action)
        updateCycle?(newState)
    }

    private func updateNextCycle(of state: State) {
        guard let (interval, action) = cycles.next() else { return }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + interval,
            execute: { self.dispatch(state, action) }
        )
    }

    /// The implementation mutates state on one action at a time (one cycle).
    /// A cycle counts as one when passing through all of reducers
    /// and middlewares.
    ///
    /// - Parameters:
    ///   - state: initial state
    ///   - actions: action sequence
    open func dispatch<I: IteratorProtocol>(_ state: State, _ actions: I)
    where I.Element == (TimeInterval, Action) {
        cycles = AnyIterator(actions)
        updateNextCycle(of: state)
    }

    open func dispatch<S: Sequence>(_ state: State, _ actions: S)
    where S.Iterator.Element == Action {
        let _actions = actions
            .lazy
            .map { (Double(0), $0) }
            .makeIterator()

        dispatch(state, _actions)
    }
}

public extension Redux {

    static func merge(_ middlewares: [Middleware]) -> Middleware {
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
