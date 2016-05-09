//
//  Arbitrary.swift
//  MyKit
//
//  Created by Hai Nguyen on 5/6/16.
//  
//

public struct Arbitrary {

    public struct Number {}
    public struct Lorem {}
    public struct Color {}
}

public extension Arbitrary {

    static func random<C: CollectionType where C.Index.Distance == Int>(`in` c: C) -> C.Generator.Element {
        precondition(!c.isEmpty, "No elements for random selecting")
        let distance = Int(arc4random_uniform(UInt32(c.count)))
        return c[c.startIndex.advancedBy(distance)]
    }

    static func random<C: CollectionType where C.Index.Distance == Int>(`in` c: C) -> C.SubSequence {
        let startDistance = Int(arc4random_uniform(UInt32(c.count)))
        let startIndex = c.startIndex.advancedBy(startDistance)

        let endDistance = Arbitrary.random(in: startDistance..<c.count) ?? startDistance
        let endIndex = c.startIndex.advancedBy(endDistance)

        return c[startIndex..<endIndex]
    }
}

public extension Arbitrary.Number {

    static func randomInt() -> Int {
        return Int(arc4random())
    }

    static func randomInt(`in` range: Range<Int>) -> Int {
        return Arbitrary.random(in: range)
    }
}

public extension Arbitrary.Lorem {

    static func randomSentence() -> String {
        return Arbitrary.random(in: LoremIpsum.sharedInstance)
    }

    static func randomParagraph() -> String {
        return Arbitrary.random(in: LoremIpsum.sharedInstance).joinWithSeparator(" ")
    }
}

public extension Arbitrary.Color {

    static func randomHex() -> String {
        let hex = arc4random_uniform(UInt32(UInt16.max))
        return String(format:  "#%06X", hex)
    }

#if os(iOS)
    static func randomValue() -> UIColor {
        let r = drand48()
        let g = drand48()
        let b = drand48()

        return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1)
    }
#elseif os(OSX)
    static func randomValue() -> NSColor {
        let r = drand48()
        let g = drand48()
        let b = drand48()

        return NSColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1)
    }
#endif
}