/*
 * Then.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation.NSObject

public protocol Then: class {}

public extension Then {

    @discardableResult
    func then(_ perform: (Self) throws -> Void) rethrows -> Self {
        try perform(self)
        return self
    }

    func andThen<U>(_ transform: (Self) throws -> U) rethrows -> U {
        return try transform(self)
    }
}

extension Box: Then {}
extension NSObject: Then {}
