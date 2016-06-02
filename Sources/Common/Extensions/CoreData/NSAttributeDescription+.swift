//
//  NSAttributeDescription+.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/28/15.
//
//

import CoreData

public extension NSAttributeDescription {

    public convenience init(name: String, type: NSAttributeType, optional: Bool = false) {
        self.init()
        self.name = name
        self.optional = optional
        self.attributeType = type
    }
}