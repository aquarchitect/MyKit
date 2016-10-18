/*
 * NSIndexPath+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen
 */

import Foundation

#if swift(>=3.0)
#else
public extension NSIndexPath {

    public var indexes: [Int] {
        return (0..<self.length).map(self.indexAtPosition)
    }

    public override var debugDescription: String {
        return "NSIndexPath: " + indexes.map(String.init).joinWithSeparator("-")
    }

    public convenience init(indexes: Int...) {
        self.init(indexes: indexes, length: indexes.count)
    }

    public convenience init(indexes: Array<Int>) {
        self.init(indexes: indexes, length: indexes.count)
    }
}

extension NSIndexPath: Comparable {}

public func ==(lhs: NSIndexPath, rhs: NSIndexPath) -> Bool {
    return lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSIndexPath, rhs: NSIndexPath) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}
#endif
