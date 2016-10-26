/*
 * Bundle+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

#if swift(>=3.0)
extension Bundle {

    static var `default`: Bundle? {
#if os(iOS)
        let platform = "iOS"
#elseif os(OSX)
        let platform = "macOS"
#endif
        return Bundle(identifier: "HaiNguyen.MyKit-\(platform)")
    }
}

#if os(OSX)
import AppKit

public extension Bundle {

    func view<V: NSView>(fromNibNamed nib: String) -> V? {
        var objects = NSArray()
        self.loadNibNamed(nib, owner: nil, topLevelObjects: &objects)

        return objects.first { $0 is V } as? V
    }
}
#endif

#else
#endif
