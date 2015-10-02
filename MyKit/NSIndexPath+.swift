//
//  NSIndexPath+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension NSIndexPath {

    final var indexes: [Int] { return (0..<self.length).map(self.indexAtPosition) }

    var standard: NSIndexPath { return NSIndexPath(indexes: self[0], self[1]) }

    convenience init(indexes: Int...) {
        self.init(indexes: indexes, length: indexes.count)
    }

    convenience init(indexes: Array<Int>) {
        self.init(indexes: indexes, length: indexes.count)
    }

    subscript(position: Int) -> Int {
        return self.indexAtPosition(position)
    }
}