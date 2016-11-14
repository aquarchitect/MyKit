/*
 * Optional+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 11/13/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

public func zip<A, B>(_ optionalA: Optional<A>, _ optionalB: Optional<B>) -> Optional<(A, B)> {
    switch (optionalA, optionalB) {
    case (let a?, let b?): return (a, b)
    default: return .none
    }
}
