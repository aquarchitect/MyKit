// 
// ActionWrapper.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import Foundation

final class ActionWrapper<T>: NSObject, NSCopying {

    let handle: (T) -> Void

    init(_ handle: @escaping (T) -> Void) {
        self.handle = handle
    }

    func copy(with zone: NSZone? = nil) -> Any {
        return ActionWrapper(self.handle)
    }
}
