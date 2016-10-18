/*
 * CountableRange+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

#if swift(>=3.0)
public extension CountableRange {

    /// Shift range by specified value
    func offsets(by n: IndexDistance) -> CountableRange {
        let start = self.index(self.lowerBound, offsetBy: n)
        let end = self.index(self.upperBound, offsetBy: n)
        return start..<end
    }
}
#endif
