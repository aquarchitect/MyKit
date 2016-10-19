/*
 * Dictionary+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

/// :nodoc:
public extension Dictionary {

#if swift(>=3.0)
    init<S: Sequence>(_ sequence: S)
        where S.Iterator.Element == Element {
        self.init()
        self.merge(sequence)
    }

    mutating func merge<S: Sequence>(_ sequence: S)
        where S.Iterator.Element == Element {
        sequence.forEach { self[$0] = $1 }
    }

    func merging<S: Sequence>(_ sequence: S) -> Dictionary
        where S.Iterator.Element == Element {
        var result = self
        result.merge(sequence)
        return result
    }
#else
    init<S: SequenceType where S.Generator.Element == Element>(sequence: S) {
        self.init()
        self.merge(sequence)
    }

    mutating func merge<S: SequenceType where S.Generator.Element == Element>(sequence: S) {
        sequence.forEach { self[$0] = $1 }
    }

    func merging<S: SequenceType where S.Generator.Element == Element>(sequence: S) -> Dictionary {
        var result = self
        result.merge(sequence)
        return result
    }
#endif
}
