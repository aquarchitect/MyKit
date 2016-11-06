/*
 * NSRelationshipDescription+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CoreData

public extension NSRelationshipDescription {

    convenience init(name: String, destination: NSEntityDescription, range: CountableRange<Int> = .init(0...0)) {
        self.init()
        self.name = name
        self.destinationEntity = destination
        self.minCount = range.lowerBound
        self.maxCount = range.upperBound - 1
    }
}
