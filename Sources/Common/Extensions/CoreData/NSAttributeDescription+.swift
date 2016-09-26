/*
 * NSAttributeDescription+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CoreData

public extension NSAttributeDescription {

    convenience init(name: String, type: NSAttributeType, isOptional: Bool = false) {
        self.init()
        self.name = name
        self.isOptional = isOptional
        self.attributeType = type
    }
}
