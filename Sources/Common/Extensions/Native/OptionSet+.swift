/*
 * OptionSet+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen. All rights reserved.
 *
 */

public extension OptionSet where RawValue == Int {

    init(bitIndexes: [Int]) {
        let rawValue: RawValue = bitIndexes.reduce(0) { $0 | 1 << $1 }
        self.init(rawValue: rawValue)
    }

    init(bitIndexes: Int...) {
        self.init(bitIndexes: bitIndexes)
    }
}
