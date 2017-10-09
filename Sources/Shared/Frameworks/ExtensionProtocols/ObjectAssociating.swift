//
// ObjectAssociating.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

import ObjectiveC

private var ObjectAssociatingKey: UInt8 = 0

public protocol ObjectAssociating: class {}

public extension ObjectAssociating {

    func setAssociatedObject<T>(_ value: T) {
        objc_setAssociatedObject(
            self, &ObjectAssociatingKey, value,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }

    func getAssociatedObject<T>() -> T? {
        return objc_getAssociatedObject(self, &ObjectAssociatingKey) as? T
    }
}
