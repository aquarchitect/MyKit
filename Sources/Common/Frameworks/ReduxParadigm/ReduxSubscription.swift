/*
 * ReduxSubscription.swift
 * MyKit
 *
 * Created by Hai Nguyen on 11/29/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

final public class ReduxSubscription<State>: Observable<State> {}

public extension ReduxSubscription {

    func makeMiddlware<ParentState, Action>(_ transform: @escaping (ParentState) -> State) -> ReduxStore<ParentState, Action>.Middleware {
        return { store, dispatch in
            return { action in
                (transform >>> self.update)(store.state)
                try dispatch(action)
            }
        }
    }
}
