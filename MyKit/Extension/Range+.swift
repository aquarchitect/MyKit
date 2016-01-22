//
//  Range+.swift
//  MyKit
//
//  Created by Hai Nguyen on 9/6/15.
//
//

public extension Range {

    /// Randomly choose element in range
    public func random() -> Element {
        let distance = Int.arbitrary() % (self.count as! Int)
        return self.startIndex.advancedBy(distance as! Element.Distance)
    }

    /// Shift range by specified value
    public func rangeByOffset(value: Int) -> Range {
        let start = self.startIndex.advancedBy(value as! Element.Distance)
        let end = self.endIndex.advancedBy(value as! Element.Distance)
        return Range(start: start, end: end)
    }
}