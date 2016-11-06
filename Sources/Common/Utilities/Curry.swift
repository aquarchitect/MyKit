/*
 * Curry.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

/**
 * This is not a true curry's definition, 
 * but inspired by the concept.
 */
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

public func >>> <T>(lhs: () -> T, rhs: (T) -> Void) {
    rhs(lhs())
}
