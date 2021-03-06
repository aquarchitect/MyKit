// 
// ProcessInfo+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
// 

import Foundation

public extension ProcessInfo {

    var isRunningUnitTest: Bool {
        return self.environment.keys.contains("XCInjectBundleInto")             // for application
            || self.environment.keys.contains("XCTestConfigurationFilePath")    // for framework
    }
}

