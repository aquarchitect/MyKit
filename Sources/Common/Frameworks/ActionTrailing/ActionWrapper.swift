/*
 * ActionWrapper.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

final class ActionWrapper<T>: NSObject, NSCopying {

    let handler: (T) -> Void

    init(_ handler: @escaping (T) -> Void) {
        self.handler = handler
    }

    func copy(with zone: NSZone? = nil) -> Any {
        return ActionWrapper(self.handler)
    }
}
