/*
 * CountableRange+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

public extension CountableRange {

    /// Shift range by specified value
    func offsets(by n: IndexDistance) -> CountableRange {
        let start = self.lowerBound.advanced(by: n)
        let end = self.upperBound.advanced(by: n)

        return start..<end
    }
}
