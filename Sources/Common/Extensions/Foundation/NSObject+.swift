//
// NSObject+.swift
// MyKit
//
// Created by Hai Nguyen on 7/5/17.
// Copyright (c) 2017 Hai Nguyen.
//

import Foundation

private var AssociatedObjectKey: UInt8 = 0

extension NSObject {

    func setAssociatedObject<T>(_ value: T) {
        objc_setAssociatedObject(
            self,
            &AssociatedObjectKey,
            value,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }

    func getAssociatedObject<T>() -> T? {
        return objc_getAssociatedObject(self, &AssociatedObjectKey) as? T
    }
}
