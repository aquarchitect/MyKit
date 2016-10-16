/*
 * Curry.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

#if swift(>=3.0)
precedencegroup Currying {
    associativity: left
}

infix operator >>>: Currying

public func >>> <A, B, C>(lhs: @escaping (A) -> B, rhs: @escaping (B) -> C) -> (A) -> C {
    return { rhs(lhs($0)) }
}

public func >>> <A, B, C>(lhs: @escaping (A) throws -> B, rhs: @escaping (B) throws -> C) -> (A) throws -> C {
    return { try rhs(try lhs($0)) }
}
#else
    infix operator >>> {}

public func >>> <A, B, C>(lhs: (A) -> B, rhs: (B) -> C) -> (A) -> C {
    return { rhs(lhs($0)) }
}

public func >>> <A, B, C>(lhs: (A) throws -> B, rhs: (B) throws -> C) -> (A) throws -> C {
    return { try rhs(try lhs($0)) }
}
#endif

public func >>> <T>(lhs: () -> T, rhs: (T) -> Void) {
    rhs(lhs())
}
