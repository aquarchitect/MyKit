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
#else
#endif
