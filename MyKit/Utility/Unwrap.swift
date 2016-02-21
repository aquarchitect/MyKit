//
//  Unwrap.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/19/16.
//  
//

infix operator ??= { associativity left }

public func ??= <A: NSObject>(inout lhs: Optional<A>, rhs: A) -> A? {
    lhs = lhs ?? rhs
    return lhs
}