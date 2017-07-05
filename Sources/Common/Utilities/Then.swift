// 
// Then.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import Foundation

/// _Then_ provides helper functions to ease the transformation of one type to another.
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
