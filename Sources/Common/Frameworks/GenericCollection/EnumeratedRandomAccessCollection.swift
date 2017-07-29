//
// EnumeratedRandomAccessCollection.swift
// MyKit
//
// Created by Hai Nguyen on 7/29/17.
// Copyright (c) 2017 Hai Nguyen.
//

public struct EnumeratedRandomAccessCollection<Base: RandomAccessCollection>: RandomAccessCollection {

    // MARK: Properties

    private let base: Base

    let block: (Index, Iterator.Element) -> Iterator.Element

    public var startIndex: Base.Index {
        return base.startIndex
    }

    public var endIndex: Base.Index {
        return base.endIndex
    }

    // MARK: Initialization

    public init(base: Base, block: @escaping (Index, Iterator.Element) -> Iterator.Element) {
        self.base = base
        self.block = block
    }

    // MARK: System Methods

    public subscript(index: Base.Index) -> Base.Iterator.Element {
        return block(index, base[index])
    }

    public func index(before i: Base.Index) -> Base.Index {
        return base.index(before: i)
    }

    public func index(after i: Base.Index) -> Base.Index {
        return base.index(after: i)
    }
}
