//
//  NSRelationshipDescription+.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/31/15.
//
//

import CoreData

public extension NSRelationshipDescription {

    public convenience init(name: String, destination: NSEntityDescription, range: Range<Int> = 0...0) {
        self.init()
        self.name = name
        self.destinationEntity = destination
        self.minCount = range.startIndex
        self.maxCount = range.endIndex - 1
    }
}