//
//  NSIndexPath+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

import Foundation

public extension NSIndexPath {

    public var indexes: [Int] { return (0..<self.length).map(self.indexAtPosition) }

    public override var debugDescription: String {
        return "NSIndexPath: " + indexes.map(String.init).joinWithSeparator("-")
    }

    public convenience init(indexes: Int...) {
        self.init(indexes: indexes, length: indexes.count)
    }

    public convenience init(indexes: Array<Int>) {
        self.init(indexes: indexes, length: indexes.count)
    }

    public func doubleIndices() -> NSIndexPath {
        return NSIndexPath(indexes: (0...1).map(self.indexAtPosition))
    }
}