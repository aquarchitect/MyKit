//
// OffsetBidirectionalCollection.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

public struct OffsetBidirectionalCollection<Base>: BidirectionalCollection where
    Base: BidirectionalCollection,
    Base.Index: SignedInteger
{

    // MARK: Properties

    private let base: Base

    let offsetValue: Index.Stride

    public var startIndex: Base.Index {
        return base.startIndex.advanced(by: offsetValue)
    }

    public var endIndex: Base.Index {
        return base.endIndex.advanced(by: offsetValue)
    }

    // MARK: Initialization

    public init(base: Base, offsetValue: Index.Stride) {
        self.base = base
        self.offsetValue = offsetValue
    }

    // MARK: System Methods

    public subscript(index: Base.Index) -> Base.Iterator.Element {
        return base[index.advanced(by: -offsetValue)]
    }

    public func index(before i: Base.Index) -> Base.Index {
        return base.index(before: i)
    }

    public func index(after i: Base.Index) -> Base.Index {
        return base.index(after: i)
    }
}
