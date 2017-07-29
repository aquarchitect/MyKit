//
// BidirectionalCollection+.swift
// MyKit
//
// Created by Hai Nguyen on 7/29/17.
// Copyright (c) 2017 Hai Nguyen.
//

public extension BidirectionalCollection {

    func permutate<S>(with indexes: S) -> PermutationBidirectionalSlice<Self> where
        S: Sequence,
        S.Iterator.Element == Index
    {
        return PermutationBidirectionalSlice(base: self, permutatedIndexes: indexes)
    }

    func enumerate(inline block: @escaping (Index, Iterator.Element) -> Iterator.Element) -> EnumeratedBidirectionalCollection<Self> {
        return EnumeratedBidirectionalCollection(base: self, block: block)
    }
}

public extension BidirectionalCollection where Index: SignedInteger {

    /// A view onto the collection with offseted indexes
    func offsetIndexes(by value: Index.Stride) -> OffsetBidirectionalCollection<Self> {
        return OffsetBidirectionalCollection(base: self, offsetValue: value)
    }
}
