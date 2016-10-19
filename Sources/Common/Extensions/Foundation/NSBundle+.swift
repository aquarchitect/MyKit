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
#endif
