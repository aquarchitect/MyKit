//
//  Currying.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/2/16.
//  
//

infix operator --> { associativity left precedence 140 }

public func --> <A, B, C>(lhs: A -> B, rhs: B -> C) -> (A -> C) {
    return { rhs(lhs($0)) }
}

public func --> <T>(@autoclosure lhs: Void -> T, rhs: T -> Void) {
    rhs(lhs())
}