// 
// Bundle+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import Foundation

public extension Bundle {

    var productName: String {
        return (self.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String) ?? ""
    }
}
