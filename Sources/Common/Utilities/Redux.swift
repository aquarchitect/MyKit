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
    private var cycles = [Action]().makeIterator()

    public init(reducers: [Reducer], middlewares: [Middleware]) {
        let reducer = Redux.merge(reducers)
        let middleware = Redux.merge(middlewares)

        input.flatMapLatest { state, action in
            reducer(state, action)
                .map { ($0, action) }
                .onNext { Swift.print($0) }
                .onError { error in
                    Swift.print(error)
                    try? middleware(state, { _ in throw error })(action)
            }
        }.onNext { state, action in
            try? middleware(state, { _ in })(action)

            DispatchQueue.main.async {
                self.updateNextCycle(state: state)
            }
        }
    }

    private func updateNextCycle(state: State) {
        cycles.next().map { input.update((state, $0)) }
    }

    /// The implementation can also handle multiple cycle 
    /// one after another.
    open func dispatch(state: State, actions: Action...) {
        cycles = actions.makeIterator()
        updateNextCycle(state: state)
    }
}

public extension Redux {

    static func merge(_ reducers: [Reducer]) -> Reducer {
        return reducers.reduce(
            { state, _ in .lift { state }},
            { result, reducer in
                { state, action in
                    result(state, action).flatMap {
                        reducer($0, action)
                    }
                }
            }
        )
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
