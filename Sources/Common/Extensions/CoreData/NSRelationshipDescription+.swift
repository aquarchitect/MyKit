/*
 * NSRelationshipDescription+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CoreData

public extension NSRelationshipDescription {

#if swift(>=3.0)
    convenience init(name: String, destination: NSEntityDescription, range: CountableRange<Int> = .init(0...0)) {
        self.init()
        self.name = name
        self.destinationEntity = destination
        self.minCount = range.lowerBound
        self.maxCount = range.upperBound - 1
    }
#else
    convenience init(name: String, destination: NSEntityDescription, range: Range<Int> = .init(0...0)) {
        self.init()
        self.name = name
        self.destinationEntity = destination
        self.minCount = range.startIndex
        self.maxCount = range.endIndex - 1
    }
#endif
}
