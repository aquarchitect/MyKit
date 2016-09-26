/*
 * ActionWrapper.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

final class ActionWrapper<T>: NSCopying {

    let block: (T) -> Void

    init(_ block: @escaping (T) -> Void) {
        self.block = block
    }

    func copy(with zone: NSZone? = nil) -> Any {
        return ActionWrapper(self.block)
    }
}
