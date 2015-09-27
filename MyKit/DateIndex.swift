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

    public init() {
        let today = TimeSystem.shareInstance.today
        self.init(value: today, unit: .Day)
    }
}

public func == (lhs: DateIndex, rhs: DateIndex) -> Bool {
    return lhs.value == rhs.value && lhs.unit == rhs.unit
}

public func < (lhs: DateIndex, rhs: DateIndex) -> Bool {
    return lhs.value.compare(rhs.value) == .OrderedAscending
}

extension DateIndex: Comparable {}

extension DateIndex: Hashable {

    public var hashValue: Int {
        return self.value.hashValue
    }
}

extension DateIndex: ForwardIndexType {

    public func successor() -> DateIndex {
        let date = self.value.dateByAddingUnit(self.unit, value: 1)
        return DateIndex(value: date, unit: self.unit)
    }

    public func advancedBy(n: Int) -> DateIndex {
        let date = self.value.dateByAddingUnit(self.unit, value: n)
        return DateIndex(value: date, unit: self.unit)
    }
}

extension DateIndex: BidirectionalIndexType {

    public func predecessor() -> DateIndex {
        let date = self.value.dateByAddingUnit(self.unit, value: -1)
        return DateIndex(value: date, unit: self.unit)
    }
}

extension DateIndex {

    public static func range(start start: NSDate, end: NSDate, unit: NSCalendarUnit = .Day) -> Range<DateIndex> {
        let startIndex = DateIndex(value: start)
        let endIndex = DateIndex(value: end)
        return startIndex..<endIndex
    }
}