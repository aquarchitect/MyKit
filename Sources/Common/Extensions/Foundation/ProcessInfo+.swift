/*
 * ProcessInfo+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 3/1/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import Foundation

public extension ProcessInfo {

    var isRunningUnitTest: Bool {
        return self.environment.keys.contains("XCInjectBundleInto")
    }
}

