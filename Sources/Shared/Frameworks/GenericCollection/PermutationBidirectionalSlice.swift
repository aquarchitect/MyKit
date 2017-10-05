//
// PermutationBidirectionalSlice.swift
// MyKit
//
// Created by Hai Nguyen on 7/29/17.
// Copyright (c) 2017 Hai Nguyen.
//

public struct PermutationBidirectionalSlice<Base: BidirectionalCollection>: BidirectionalCollection {
    
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

    public func index(before i: Int) -> Int {
        return permutatedIndexes.index(before: i)
    }

    public func index(after i: Int) -> Int {
        return permutatedIndexes.index(after: i)
    }
}
