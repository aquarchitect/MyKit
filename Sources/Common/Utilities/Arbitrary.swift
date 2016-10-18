/*
 * Arbitrary.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Darwin

/// _Arbitray_ helps selecting element randomly.
public struct Arbitrary {}

public extension Arbitrary {

#if swift(>=3.0)
    static func element<C: Collection>(in c: C) -> C.Iterator.Element
    where C.IndexDistance == Int {
        precondition(!c.isEmpty, "No elements for random selecting")

        let distance = Int(arc4random_uniform(UInt32(c.count)))
        return c[c.index(c.startIndex, offsetBy: distance)]
    }

    static func subsequence<C: Collection>(in c: C) -> C.SubSequence
    where C.IndexDistance == Int {
        let startDistance = Int(arc4random_uniform(UInt32(c.count)))
        let startIndex = c.index(c.startIndex, offsetBy: startDistance)

        let endDistance = element(in: startDistance..<c.count)
        let endIndex = c.index(c.startIndex, offsetBy: endDistance)

        return c[startIndex..<endIndex]
    }
#else
    static func element<C: CollectionType where C.Index.Distance == Int>(in c: C) -> C.Generator.Element {
        precondition(!c.isEmpty, "No elements for random selecting")

        let distance = Int(arc4random_uniform(UInt32(c.count)))
        return c[c.startIndex.advancedBy(distance)]
    }

    static func subsequence<C: CollectionType where C.Index.Distance == Int>(in c: C) -> C.SubSequence {
        let startDistance = Int(arc4random_uniform(UInt32(c.count)))
        let startIndex = c.startIndex.advancedBy(startDistance)

        let endDistance = element(in: startDistance..<c.count)
        let endIndex = c.startIndex.advancedBy(endDistance)

        return c[startIndex..<endIndex]
    }
#endif
}

// MARK: - Primitive Types

public extension Arbitrary {

    static var bool: Bool {
        return int % 2 == 0
    }

    static var int: Int {
        return Int(arc4random())
    }

    static func int(in range: CountableRange<Int>) -> Int {
        return element(in: range)
    }
}

// MARK: - Hexadecimal Value

public extension Arbitrary {

    static var hexString: String {
        let value = arc4random_uniform(UInt32(UInt16.max))
        return String(format: "#%06X", value)
    }

    static var hexUInt: UInt {
        return UInt(arc4random_uniform(UInt32(UInt16.max)))
    }
}

// MARK: - Lorem Ipsum

public extension Arbitrary {

    static var sentence: String {
        return element(in: _LoremIpsum.shared)
    }

    static var paragraph: String {
        return subsequence(in: _LoremIpsum.shared).joined(separator: ". ")
    }
}
