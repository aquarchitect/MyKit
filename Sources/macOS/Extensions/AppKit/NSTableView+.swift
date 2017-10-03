// 
// NSTableView+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
// 

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

#if !swift(>=3.2)
public extension NSTableView {

    func make<V: NSView>(for owner: Any?) -> V where V: Then {
        let identifier = String(describing: V.self)
        
        return self.make(
            withIdentifier: identifier,
            owner: owner
        ) as? V ?? V().then {
            $0.identifier = identifier
        }
    }
}
#endif
