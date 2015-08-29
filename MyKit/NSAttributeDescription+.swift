//
//  NSAttributeDescription+.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/28/15.
//
//

public extension NSAttributeDescription {

    public convenience init(name: String, type: NSAttributeType, optional: Bool = true) {
        self.init()
        self.name = name
        self.optional = optional
        self.attributeType = type
    }
}