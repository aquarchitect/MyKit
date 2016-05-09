//
//  NSRange+.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/29/15.
//
//

// :nodoc:
public func == (lhs: NSRange, rhs: NSRange) -> Bool {
    return lhs.location == rhs.location && lhs.length == rhs.length
}

extension NSRange: Equatable {}