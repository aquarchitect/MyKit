// 
// NSRange+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import Foundation

public extension NSRange {

    func clamped(to range: NSRange) -> NSRange {
        // this condition prevents crash when length of range
        // is negative even though toRange returns an optional
        guard self.length >= 0
            && range.length >= 0
            else { return self }

        return zip(self.toRange(), range.toRange())
            .map({ $0.clamped(to: $1) })
            .map(NSRange.init)
            ?? self
    }
}

// :nodoc:
public func == (lhs: NSRange, rhs: NSRange) -> Bool {
    return lhs.location == rhs.location && lhs.length == rhs.length
}

extension NSRange: Equatable {}
