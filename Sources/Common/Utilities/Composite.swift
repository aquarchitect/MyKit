/*
 * Composite.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

precedencegroup Composite {
    associativity: left
}

infix operator •: Composite

public func • <A, B, C>(lhs: @escaping (B) -> C, rhs: @escaping (A) -> B) -> (A) -> C {
    return { lhs(rhs($0)) }
}

public func • <A, B, C>(lhs: @escaping (B) throws -> C, rhs: @escaping (A) throws -> B) -> (A) throws -> C {
    return  { try lhs(try rhs($0)) }
}

public func • <A, B, C>(lhs: ((B) throws -> C)?, rhs: ((A) throws -> B)?) -> ((A) throws -> C)? {
    return zip(lhs, rhs).map { unwrappedLhs, unwrappedRhs in
        { try unwrappedLhs(try unwrappedRhs($0)) }
    }
}
