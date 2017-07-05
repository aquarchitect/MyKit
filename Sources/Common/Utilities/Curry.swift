//
// Curry.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

public func curry<A, B>(_ f: @escaping (A) -> B) -> (A) -> B {
    return { (a: A) -> B in
        f(a)
    }
}

public func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { (a: A) -> (B) -> C in
        { (b: B) -> C in
            f(a, b)
        }
    }
}

public func curry<A, B, C, D>(_ f: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    return { (a: A) -> (B) -> (C) -> D in
        { (b: B) -> (C) -> D in
            { (c: C) -> D in
                f(a, b, c)
            }
        }
    }
}
