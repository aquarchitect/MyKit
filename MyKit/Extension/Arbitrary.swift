//
//  Arbitrary.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/29/15.
//
//

/// Type that can be chosen randomly
public protocol Arbitrary {

    static func arbitrary() -> Self
}

extension Int: Arbitrary {

    /// Random integer
    public static func arbitrary() -> Int {
        return Int(arc4random())
    }
}

extension Character: Arbitrary {

    /// Random character
    public static func arbitrary() -> Character {
        let unicode = UnicodeScalar((65...90).random())
        return Character(unicode)
    }
}