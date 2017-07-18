//
// PermutationSlice.swift
// MyKit
//
// Created by Hai Nguyen on 7/18/17.
// Copyright (c) 2017 Hai Nguyen.
//

/// A view into the collection whose elements are in a permutated order.
public struct PermutationSlice<Base: Collection>: Collection {
    // MARK: Properties

    private let base: Base

    let permutatedIndexes: [Base.Index]

    public var startIndex: Int {
        return permutatedIndexes.startIndex
    }

    public var endIndex: Int {
        return permutatedIndexes.endIndex
    }

    // MARK: Initialization

    public init<S>(base: Base, permutatedIndexes: S) where
        S: Sequence,
        S.Iterator.Element == Base.Index
    {
        self.base = base
        self.permutatedIndexes = Array(permutatedIndexes)
    }

    // MARK: System Methods

    public subscript(index: Int) -> Base.Iterator.Element {
        return base[permutatedIndexes[index]]
    }

    public func index(after i: Int) -> Int {
        return permutatedIndexes.index(after: i)
    }
}
