/*
 * NSAttributeDescription+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CoreData

public extension NSAttributeDescription {

#if swift(>=3.0)
    convenience init(name: String, type: NSAttributeType, isOptional: Bool = false) {
        self.init()
        self.name = name
        self.isOptional = isOptional
        self.attributeType = type
    }
#else
    convenience init(name: String, type: NSAttributeType, optional: Bool = false) {
        self.init()
        self.name = name
        self.optional = optional
        self.attributeType = type
    }
#endif
}
