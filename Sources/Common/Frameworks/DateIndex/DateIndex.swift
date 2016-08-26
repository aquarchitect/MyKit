/*
 * DateIndex.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

public struct DateIndex {

    public let value: NSDate
    public var unit: NSCalendarUnit

    public init(value: NSDate, unit: NSCalendarUnit = .Day) {
        self.value = value
        self.unit = unit
    }
}

extension DateIndex: ForwardIndexType {

    public func successor() -> DateIndex {
        return value.dateByAdding(unit, value: 1)
            .andThen { DateIndex(value: $0, unit: unit) }
    }

    public func advancedBy(n: Int) -> DateIndex {
        return value.dateByAdding(unit, value: n)
            .andThen { DateIndex(value: $0, unit: unit) }
    }
}

extension DateIndex: BidirectionalIndexType {

    public func predecessor() -> DateIndex {
        return value.dateByAdding(unit, value: -1)
            .andThen { DateIndex(value: $0, unit: unit) }
    }
}

extension DateIndex: Comparable {}

extension DateIndex: Hashable {

    public var hashValue: Int {
        return self.value.hashValue
    }
}

/// :nodoc:
public func == (lhs: DateIndex, rhs: DateIndex) -> Bool {
    return lhs.value == rhs.value && lhs.unit == rhs.unit
}

/// :nodoc:
public func < (lhs: DateIndex, rhs: DateIndex) -> Bool {
    return lhs.value.compare(rhs.value) == .OrderedAscending
}