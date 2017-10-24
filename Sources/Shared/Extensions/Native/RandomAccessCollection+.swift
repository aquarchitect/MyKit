//
// RandomAccessCollection+.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

public extension RandomAccessCollection {

    func permutate<S>(with indexes: S) -> PermutationRandomAccessSlice<Self> where
        S: Sequence,
        S.Iterator.Element == Index
    {
        return PermutationRandomAccessSlice(base: self, permutatedIndexes: indexes)
    }

    func enumerate(inline block: @escaping (Index, Iterator.Element) -> Iterator.Element) -> EnumeratedRandomAccessCollection<Self> {
        return EnumeratedRandomAccessCollection(base: self, block: block)
    }
}

public extension RandomAccessCollection where Index: SignedInteger, Index.Stride: SignedInteger {

    /// A view onto the collection with offseted indexes
    func offsetIndexes(by value: Index.Stride) -> OffsetRandomAccessCollection<Self> {
        return OffsetRandomAccessCollection(base: self, offsetValue: value)
    }
}
