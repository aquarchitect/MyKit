// 
// Then.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import Foundation

/// The protocol simply provides a couple of helper functions to configure the object instance.
///
/// - warning: `map` and `flatMap` should be favored in the case of `Optional`.
public protocol Then: class {}

public extension Then {

    @discardableResult
    func then(_ perform: (Self) throws -> Void) rethrows -> Self {
        try perform(self)
        return self
    }

    func andThen<U>(_ transformer: (Self) throws -> U) rethrows -> U {
        return try transformer(self)
    }
}

extension NSObject: Then {}
extension Box: Then {}
