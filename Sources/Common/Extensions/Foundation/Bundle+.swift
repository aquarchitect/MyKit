/*
 * Bundle+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

extension Bundle {

    static var `default`: Bundle? {
#if os(iOS)
        let platform = "iOS"
#elseif os(macOS)
        let platform = "macOS"
#endif
        return Bundle(identifier: "HaiNguyen.MyKit-\(platform)")
    }
}
