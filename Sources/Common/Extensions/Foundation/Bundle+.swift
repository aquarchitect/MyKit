// 
// Bundle+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import Foundation

extension Bundle {

    var productName: String {
        return (self.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String) ?? ""
    }

    static var `default`: Bundle? {
#if os(iOS)
        let platform = "iOS"
#elseif os(OSX)
        let platform = "macOS"
#endif
        return Bundle(identifier: "HaiNguyen.MyKit-\(platform)")
    }
}
