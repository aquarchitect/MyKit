/*
 * OptionSetType+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 10/18/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

#if swift(>=3.0)
#else
public extension OptionSetType where RawValue == Int {

    init(bitIndexes: [Int]) {
        let rawValue: RawValue = bitIndexes.reduce(0) { $0 | 1 << $1 }
        self.init(rawValue: rawValue)
    }

    init(bitIndexes: Int...) {
        self.init(bitIndexes: bitIndexes)
    }
}
#endif
