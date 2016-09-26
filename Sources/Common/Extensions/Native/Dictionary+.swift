/*
 * Dictionary+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

/// :nodoc:
public extension Dictionary {

    init<S: Sequence>(sequence: S)
        where S.Iterator.Element == Element {
        self.init()
        self.merge(sequence: sequence)
    }

    mutating func merge<S: Sequence>(sequence: S)
        where S.Iterator.Element == Element {
        sequence.forEach { self[$0] = $1 }
    }

    func merging<S: Sequence>(sequence: S) -> Dictionary
        where S.Iterator.Element == Element {
        var result = self
        result.merge(sequence: sequence)
        return result
    }
}
