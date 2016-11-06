/*
 * RangeReplaceableCollection+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

public extension RangeReplaceableCollection where Index == Int {

    mutating func apply(_ changes: [Change<(index: Index, element: Iterator.Element)>]) {
        for change in changes {
            switch change {
            case .delete(let step): self.remove(at: step.index)
            case .insert(let step): self.insert(step.element, at: step.index)
            }
        }
    }

    func applying(_ changes: [Change<(index: Index, element: Iterator.Element)>]) -> Self {
        var result = self
        result.apply(changes)
        return result
    }
}
