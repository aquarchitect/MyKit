//
// Benchmark.swift
// MyKit
//
// Created by Hai Nguyen on 5/5/17.
// Copyright (c) 2017 Hai Nguyen.
//

import Foundation

public func benchmark( _ block: () -> Void) {
    let startTime = CFAbsoluteTimeGetCurrent()
    block()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime

    print("Time elapsed: \(timeElapsed)s")
}
