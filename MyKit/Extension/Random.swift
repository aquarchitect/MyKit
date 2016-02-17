//
//  Random.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/29/15.
//
//

/// Type that can be chosen randomly
public protocol Random {

    static var random: Self { get }
}

extension Int: Random {

    /// Random integer
    public static var random: Int {
        return Int(arc4random())
    }
}

//extension Character: Random {

//    / Random character
//    public static func random() -> Character {
//        let unicode = UnicodeScalar((65...90).random())
//        return Character(unicode)
//    }
//}