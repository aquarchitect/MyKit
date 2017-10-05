// 
// Arbitrary.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import Darwin

/// _Arbitray_ helps selecting element randomly.
public enum Arbitrary {}

public extension Arbitrary {

    /// Return a collection of arbitrary elements using selection 
    /// sampling technique. The method keeps the original elements
    /// order in tact.
    ///
    /// - See Also: [Algorithm Alley](http://profesores.elo.utfsm.cl/~tarredondo/info/soft-comp/codigo/dt/id-3%20algorithm.pdf)
    static func elements<C>(in c: C, count requested: Int) -> [C.Iterator.Element] where
        C: Collection,
        C.IndexDistance == Int
    {
        var examined = 0, selected = 0
        var results: [C.Iterator.Element] = []
        results.reserveCapacity(requested)

        while selected < requested {
            examined += 1

            let random = Double(int) / 0x100000000
            let leftToExam = c.count - examined + 1
            let leftToAdd = requested - selected

            if Double(leftToExam) * random < Double(leftToAdd) {
                results.append(c[c.index(c.startIndex, offsetBy: examined - 1)])
                selected += 1
            }
        }

        return results
    }

    static func element<C>(in c: C) -> C.Iterator.Element where
        C: Collection,
        C.IndexDistance == Int
    {
        precondition(!c.isEmpty, "No elements for random selecting")
        return elements(in: c, count: 1)[0]
    }

    static func subsequence<C>(in c: C) -> C.SubSequence where
        C: Collection,
        C.IndexDistance == Int
    {
        let startDistance = Int(arc4random_uniform(UInt32(c.count)))
        let startIndex = c.index(c.startIndex, offsetBy: startDistance)

        let endDistance = element(in: startDistance..<c.count)
        let endIndex = c.index(c.startIndex, offsetBy: endDistance)

        return c[startIndex..<endIndex]
    }
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
        return element(in: ColorPalette.shared)
    }

    static var hexUInt: UInt {
        return element(in: ColorPalette.shared.flatMap({ $0.hexUInt }))
    }
}

// MARK: - Lorem Ipsum

public extension Arbitrary {

    static var word: String {
        let collection = element(in: LoremIpsum.shared)
            .components(separatedBy: " ")
        return element(in: collection).capitalized
    }

    static var sentence: String {
        return element(in: LoremIpsum.shared)
    }

    static var paragraph: String {
        return subsequence(in: LoremIpsum.shared)
            .joined(separator: ". ")
    }
}
