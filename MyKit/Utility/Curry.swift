//
//  Curry.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/2/16.
//  
//

infix operator >>> { associativity left }

public func >>> <A, B, C>(lhs: A -> B, rhs: B -> C) -> (A -> C) {
    return { rhs(lhs($0)) }
}

public func >>> <T>(lhs: Void -> T, rhs: T -> Void) {
    rhs(lhs())
}

public func >>> <A, B, C>(lhs: A -> B, rhs: (B -> C)?) -> A -> C? {
    return { rhs?(lhs($0)) }
}