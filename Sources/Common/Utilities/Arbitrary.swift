//
//  Arbitrary.swift
//  MyKit
//
//  Created by Hai Nguyen on 5/6/16.
//  
//

import Foundation

public struct Arbitrary {}

public extension Arbitrary {

    static func element<C: CollectionType where C.Index.Distance == Int>(`in` c: C) -> C.Generator.Element {
        precondition(!c.isEmpty, "No elements for random selecting")

        let distance = Int(arc4random_uniform(UInt32(c.count)))
        return c[c.startIndex.advancedBy(distance)]
    }

    static func subsequence<C: CollectionType where C.Index.Distance == Int>(`in` c: C) -> C.SubSequence {
        let startDistance = Int(arc4random_uniform(UInt32(c.count)))
        let startIndex = c.startIndex.advancedBy(startDistance)

        let endDistance = element(in: startDistance..<c.count)
        let endIndex = c.startIndex.advancedBy(endDistance)

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

    static func int(`in` range: Range<Int>) -> Int {
        return element(in: range)
    }
}

public extension Arbitrary {

    static var hexCode: String {
        let value = arc4random_uniform(UInt32(UInt16.max))
        return String(format: "#%06X", value)
    }
}

public extension Arbitrary {

    static var sentence: String {
        return element(in: LoremIpsum.sharedInstance)
    }

    static var paragraph: String {
        return subsequence(in: LoremIpsum.sharedInstance).joinWithSeparator(". ")
    }
}