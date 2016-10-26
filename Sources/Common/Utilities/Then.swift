/*
 * Then.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

/// _Then_ provides helper functions to ease the transformation of one type to another.
///
/// - warning: `map` and `flatMap` should be favored in the case of `Optional`.
public protocol Then: class {}

public extension Then {

#if swift(>=3.0)
    @discardableResult
    func then(_ perform: (Self) throws -> Void) rethrows -> Self {
        try perform(self)
        return self
    }

    func andThen<U>(_ transform: (Self) throws -> U) rethrows -> U {
        return try transform(self)
    }
#else
    func then(@noescape perform: (Self) throws -> Void) rethrows -> Self {
        try perform(self)
        return self
    }

    @warn_unused_result
    func andThen<U>(@noescape transform: (Self) throws -> U) rethrows -> U {
        return try transform(self)
    }
#endif
}

extension Box: Then {}
extension NSObject: Then {}

#if swift(>=3.0)
#elseif os(iOS)
import UIKit
extension UIView: Then {}
#endif
