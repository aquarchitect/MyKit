//
//  DateIndex.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/31/15.
//
//

public struct DateIndex {

    public let date: NSDate
    public let unit: NSCalendarUnit

    public init(date: NSDate, unit: NSCalendarUnit) {
        self.date = date
        self.unit = unit
    }
}

extension DateIndex: Equatable {}

extension DateIndex: ForwardIndexType {

    public func successor() -> DateIndex {
        let date = self.date.dateByAddingUnit(self.unit, value: 1)
        return DateIndex(date: date, unit: self.unit)
    }

    public func advancedBy(n: Int) -> DateIndex {
        let date = self.date.dateByAddingUnit(self.unit, value: n)
        return DateIndex(date: date, unit: self.unit)
    }
}

extension DateIndex: BidirectionalIndexType {

    public func predecessor() -> DateIndex {
        let date = self.date.dateByAddingUnit(self.unit, value: -1)
        return DateIndex(date: date, unit: self.unit)
    }
}

public func == (lhs: DateIndex, rhs: DateIndex) -> Bool {
    return lhs.date == rhs.date && lhs.unit == rhs.unit
}