//
//  NSIndexPath+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

public extension NSIndexPath {

    public var indexes: [Int] { return (0..<self.length).map(self.indexAtPosition) }

    public var standard: NSIndexPath { return NSIndexPath(indexes: self[0], self[1]) }

    public convenience init(indexes: Int...) {
        self.init(indexes: indexes, length: indexes.count)
    }

    public convenience init(indexes: Array<Int>) {
        self.init(indexes: indexes, length: indexes.count)
    }

    public subscript(position: Int) -> Int {
        return self.indexAtPosition(position)
    }

    public func clone() -> NSIndexPath {
        return NSIndexPath(indexes: indexes)
    }
}