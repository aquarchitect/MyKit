/*
 * NSTableView+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 3/1/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import AppKit

public extension NSTableView {

    var rangeOfVisibleRows: CountableRange<Int> {
        return Optional(self.visibleRect)
            .map(self.rows(in:))
            .flatMap { $0.toRange() }
            .map(CountableRange.init)
            ?? .init(0 ..< 0)
    }

    var indexesOfVisibleRows: IndexSet {
        return IndexSet(integersIn: rangeOfVisibleRows)
    }
}
