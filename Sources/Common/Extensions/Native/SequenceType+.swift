//
//  SequenceType+.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/1/16.
//  
//

/// :nodoc:
public extension SequenceType {

    public func pair<K: Hashable, V>(@noescape f: Generator.Element throws -> (K, V)) rethrows -> [K: V] {
        var results: [K: V] = [:]

        try self.forEach {
            let element = try f($0)
            results[element.0] = element.1
        }

        return results
    }
}