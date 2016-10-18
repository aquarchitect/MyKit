/*
 * RangeReplaceableCollectionType+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 10/18/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

#if swift(>=3.0)
#else
public extension RangeReplaceableCollectionType where Index == Int {

    mutating func apply(changes: [Change<(index: Index, element: Generator.Element)>]) {
        for change in changes {
            switch change {
            case .delete(let step): self.removeAtIndex(step.index)
            case .insert(let step): self.insert(step.element, atIndex: step.index)
            }
        }
    }

    func applying(changes: [Change<(index: Index, element: Generator.Element)>]) -> Self {
        var result = self
        result.apply(changes)
        return result
    }
}
#endif
