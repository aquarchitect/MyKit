//
// RandomAccessCollection+.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

extension RandomAccessCollection {

    func element(at index: Index) -> Iterator.Element? {
        let distance = self.distance(from: self.startIndex, to: index)

        return self.index(
            self.startIndex,
            offsetBy: distance,
            limitedBy: self.endIndex
        ).map { self[$0] }
    }
}

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
