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

public func • <A, B, C>(lhs: @escaping (A) -> B, rhs: @escaping (B) -> C) -> (A) -> C {
    return { rhs(lhs($0)) }
}

public func • <A, B, C>(lhs: @escaping (A) throws -> B, rhs: @escaping (B) throws -> C) -> (A) throws -> C {
    return { try rhs(try lhs($0)) }
}
