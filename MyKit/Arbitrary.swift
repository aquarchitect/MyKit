//
//  Arbitrary.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/29/15.
//
//

public protocol Arbitrary {

    static func arbitrary() -> Self
}

extension Int: Arbitrary {

    public static func arbitrary() -> Int {
        return Int(arc4random())
    }
}

extension Range where Element.Distance: IntegerType {

    public func arbitrary() -> Element {
        let distance = Int.arbitrary() % self.count.hashValue as! Element.Distance
        return self.startIndex.advancedBy(distance)
    }
}