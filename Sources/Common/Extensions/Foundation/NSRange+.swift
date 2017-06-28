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
