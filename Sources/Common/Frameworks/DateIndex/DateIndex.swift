//
//  DateIndex.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/31/15.
//
//

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
            .then { DateIndex(value: $0, unit: unit) }
    }

    public func advancedBy(n: Int) -> DateIndex {
        return value.dateByAdding(unit, value: n)
            .then { DateIndex(value: $0, unit: unit) }
    }
}

extension DateIndex: BidirectionalIndexType {

    public func predecessor() -> DateIndex {
        return value.dateByAdding(unit, value: -1)
            .then { DateIndex(value: $0, unit: unit) }
    }
}

extension DateIndex: Comparable {}

extension DateIndex: Hashable {

    public var hashValue: Int {
        return self.value.hashValue
    }
}

// :nodoc:
public func == (lhs: DateIndex, rhs: DateIndex) -> Bool {
    return lhs.value == rhs.value && lhs.unit == rhs.unit
}

public func < (lhs: DateIndex, rhs: DateIndex) -> Bool {
    return lhs.value.compare(rhs.value) == .OrderedAscending
}