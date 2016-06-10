/*
 * Arbitrary.swift
 *
 * Copyright (c) 2015–2016 Hai Nguyen (http://aquarchitect.github.io)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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
        return element(in: _LoremIpsum.sharedInstance)
    }

    static var paragraph: String {
        return subsequence(in: _LoremIpsum.sharedInstance).joinWithSeparator(". ")
    }
}