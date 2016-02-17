//
//  Range+.swift
//  MyKit
//
//  Created by Hai Nguyen on 9/6/15.
//
//

public extension Range {

    /// Shift range by specified value
    public func offsetedBy(n: Element.Distance) -> Range {
        let start = self.startIndex.advancedBy(n)
        let end = self.endIndex.advancedBy(n)
        return start..<end
    }
}