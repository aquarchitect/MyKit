/*
 * NSBundle+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import Foundation

#if swift(>=3.0)
#else
extension NSBundle {

    static func defaultBundle() -> NSBundle? {
#if os(iOS)
        let platform = "iOS"
#elseif os(OSX)
        let platform = "macOS"
#endif
        return NSBundle(identifier: "HaiNguyen.MyKit-\(platform)")
    }
}

#if os(OSX)
import AppKit

extension NSBundle {

    func viewFromNibNamed<V: NSView>(nib: String) -> V? {
        var objects: NSArray?
        self.loadNibNamed(nib, owner: nil, topLevelObjects: &objects)

        return objects?.filter { $0 is V }.first as? V
    }
}
#endif
#endif
