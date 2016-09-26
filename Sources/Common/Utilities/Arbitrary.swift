/*
 * Arbitrary.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Darwin

public struct Arbitrary {}

public extension Arbitrary {

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
}

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

public extension Arbitrary {

    static var hexString: String {
        let value = arc4random_uniform(UInt32(UInt16.max))
        return String(format: "#%06X", value)
    }

    static var hexUInt: UInt {
        return UInt(arc4random_uniform(UInt32(UInt16.max)))
    }
}

public extension Arbitrary {

    static var sentence: String {
        return element(in: _LoremIpsum.shared)
    }

    static var paragraph: String {
        return subsequence(in: _LoremIpsum.shared).joined(separator: ". ")
    }
}
