//
//  NSIndexPath+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension NSIndexPath {

    final var array: Array<NSIndexPath> { return [self] }

    /// 2-node indexpath; standardize for UITableView and UICollectionView
    final var standard: NSIndexPath {
        return NSIndexPath(indexes: [self[0], self[1]], length: 2)
    }

    final func append(indexes: Int...) -> NSIndexPath {
        return indexes.reduce(self) { $0.indexPathByAddingIndex($1) }
    }

    final subscript(pos: Int) -> Int {
        assert(pos < self.length)
        return self.indexAtPosition(pos)
    }
}