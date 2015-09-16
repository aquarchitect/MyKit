//
//  IndexPath.swift
//  MyKit
//
//  Created by Hai Nguyen on 9/6/15.
//
//

public struct IndexPath {

    public let indexes: [Int]
    public let node: Int

    public var indexPath: NSIndexPath { return NSIndexPath(indexes: indexes) }
    public var standard: NSIndexPath { return NSIndexPath(indexes: indexes[0], indexes[1]) }

    public init(indexes: [Int], node: Int) {
        let range = NSMakeRange(0, indexes.count)
        let check = NSLocationInRange(node, range)
        assert(check)

        self.indexes = indexes
        self.node = node
    }

    public init(value: NSIndexPath, node: Int) {
        self.init(indexes: value.indexes, node: node)
    }

    public func indexPathByAddingIndex(index: Int) -> IndexPath {
        return IndexPath(indexes: self.indexes + [index], node: self.node)
    }

    public subscript(position: Int) -> Int {
        return indexes[position]
    }
}

public func == (lhs: IndexPath, rhs: IndexPath) -> Bool {
    return lhs.indexes == rhs.indexes && lhs.node == rhs.node
}

public func < (lhs: IndexPath, rhs: IndexPath) -> Bool {
    return lhs.indexPath.compare(rhs.indexPath) == .OrderedAscending
}

extension IndexPath: Comparable {}

extension IndexPath: ForwardIndexType {

    public func successor() -> IndexPath {
        var indexes = self.indexes
        indexes[node]++

        return IndexPath(indexes: indexes, node: self.node)
    }
}

extension IndexPath: BidirectionalIndexType {

    public func predecessor() -> IndexPath {
        var indexes = self.indexes
        indexes[node]--

        return IndexPath(indexes: indexes, node: self.node)
    }
}

extension IndexPath: CustomDebugStringConvertible {

    public var debugDescription: String {
        return indexes.map { "\($0)" }.joinWithSeparator("-")
    }
}