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
    static func elementInCollection<C: CollectionType where C.Index.Distance == Int>(collection: C) -> C.Generator.Element {
        precondition(!collection.isEmpty, "No elements for random selecting")

        let distance = Int(arc4random_uniform(UInt32(collection.count)))
        return collection[collection.startIndex.advancedBy(distance)]
    }

    static func subsequenceInCollection<C: CollectionType where C.Index.Distance == Int>(collection: C) -> C.SubSequence {
        let startDistance = Int(arc4random_uniform(UInt32(collection.count)))
        let startIndex = collection.startIndex.advancedBy(startDistance)

        let endDistance = elementInCollection(startDistance..<collection.count)
        let endIndex = collection.startIndex.advancedBy(endDistance)

        return collection[startIndex..<endIndex]
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

#if swift(>=3.0)
    static func int(in range: CountableRange<Int>) -> Int {
        return element(in: range)
    }
#else
    static func intInRange(range: Range<Int>) -> Int {
        return elementInCollection(range)
    }
#endif
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
#if swift(>=3.0)
        return element(in: _LoremIpsum.shared)
#else
        return (_LoremIpsum.sharedInstance >>> elementInCollection)()
#endif
    }

    static var paragraph: String {
#if swift(>=3.0)
        return subsequence(in: _LoremIpsum.shared).joined(separator: ". ")
#else
        return (_LoremIpsum.sharedInstance >>> subsequenceInCollection)().joinWithSeparator(". ")
#endif
    }
}
