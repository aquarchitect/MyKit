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
 * unidirectional architecture flow from web development. The idea is to encapsulate
 * the single apllication STATE mutation with systematic ACTIONs.
 *
 * The key different components are:
 * - The application STATE is no longer being store in the Redux object by default, 
 *   and encouraged to encapsulate inside a middleware (AppStore). This approach 
 *   provides a much flexibility in term of when to commit STATE changes based on
 *   actions.
 * - ACTIONs recorder is proved to be not only helpful in debugging mode but also
 *   calculate the redundant information of application STATE, i.e selected index.
 * - All of potential errors are directed to be handled in one of the middlewares.
 *   By positioning it first in the queue, state subscription not only catches
 *   errors from reducers but also from other middlewares.
 */
open class Redux<State, Action> {

    public typealias Reducer = (State, Action) -> Observable<State>
    public typealias Dispatcher = (Action) throws -> Void
    public typealias Middleware = (State, @escaping Dispatcher) -> Dispatcher

    private let input = Observable<(State, Action)>()

    // one cycle = reducers + middlewares
    private var cycles = AnyIterator<(TimeInterval, Action)>(EmptyIterator())

    public init(reducers: [Reducer], middlewares: [Middleware]) {
        let reducer = Redux.merge(reducers)
        let middleware = Redux.merge(middlewares)

        input.flatMapLatest { oldState, action in
            reducer(oldState, action)
                .onError { error in
                    // redirect reducer errors to one of the middles
                    try? middleware(oldState, { _ in throw error })(action)
                }.onNext { newState in
                    try? middleware(newState, { _ in })(action)
                }
        }.onNext { state in
            self.updateNextCycle(of: state)
        }
    }

    private func updateNextCycle(of state: State) {
        guard let (interval, action) = cycles.next() else { return }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + interval,
            execute: { self.input.update((state, action)) }
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

    static func merge(_ reducers: [Reducer]) -> Reducer {
        /* 
         * The implementation can start with an empty observable;
         * however, it would add another uneccessary layer of
         * obserable to the final merged reducer.
         */
        if let firstReducer = reducers.first {
            return reducers.dropFirst().reduce(
                firstReducer,
                { result, reducer in
                    { state, action in
                        result(state, action).flatMap {
                            reducer($0, action)
                        }
                    }
                }
            )
        } else {
            return { state, _ in .lift { state }}
        }
    }

    static func merge(_ reducers: Reducer...) -> Reducer {
        return merge(reducers)
    }

    static func merge(_ middlewares: [Middleware]) -> Middleware {
        return { state, dispatch in
            middlewares.reversed().reduce(dispatch, { $1(state, $0) })
        }
    }

    static func merge(_ middlerwares: Middleware...) -> Middleware {
        return merge(middlerwares)
    }
}
