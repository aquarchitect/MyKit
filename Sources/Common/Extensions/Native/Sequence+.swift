/*
 * Sequence+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

/// :nodoc:
public extension Sequence {

    public func pair<Key: Hashable, Value>(_ transformer: (Iterator.Element) throws -> (Key, Value)) rethrows -> Dictionary<Key, Value> {
        var results: [Key: Value] = Dictionary(minimumCapacity: self.underestimatedCount)

        try self.forEach {
            let element = try transformer($0)
            results[element.0] = element.1
        }

        return results
    }
}
