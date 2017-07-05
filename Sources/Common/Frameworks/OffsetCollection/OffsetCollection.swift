//
// OffsetCollection.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

/// A collection whose index starts at `offsetValue`.
public struct OffsetCollection<Base>: Collection where
    Base: Collection,
    Base.Index: SignedInteger
{

    // MARK: Properties

    private let base: Base

    let offsetValue: IndexDistance

    public var startIndex: Base.Index {
        return base.startIndex.advanced(by: offsetValue)
    }

    public var endIndex: Base.Index {
        return base.endIndex.advanced(by: offsetValue)
    }

    // MARK: Initialization

    public init(base: Base, offsetValue: IndexDistance) {
        self.base = base
        self.offsetValue = offsetValue
    }

    // MARK: System Methods

    public subscript(index: Base.Index) -> Base.Iterator.Element {
        return base[index.advanced(by: -offsetValue)]
    }

    public func index(after i: Base.Index) -> Base.Index {
        return base.index(after: i)
    }
}
