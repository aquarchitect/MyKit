//
// Heckel.swift
// MyKit
//
// Created by Hai Nguyen on 6/21/17.
// Copyright (c) 2017 Hai Nguyen.
//

public enum Heckel {

    enum Counter {

        case zero, one, many
    }

    public enum Diff<T> {

        case insert(T)
        case delete(T)
        case move(T, T)
        case update(T)
    }

    final class Symbol {

        var oc: Counter = .zero
        var nc: Counter = .zero
        var olno: [Int] = []
    }

    enum Entry {

        case symbol(Symbol)
        case index(Int)
    }
}

extension Heckel.Counter {

    mutating func increment() {
        switch self {
        case .zero: self = .one
        case .one: self = .many
        case .many: break
        }
    }
}

extension Heckel.Counter: CustomStringConvertible {

    var description: String {
        switch self {
        case .zero: return "zero"
        case .one: return "one"
        case .many: return "many"
        }
    }
}

public extension Heckel.Diff {

    func map<U>(_ transformer: (T) throws -> U) rethrows -> Heckel.Diff<U> {
        switch self {
        case .insert(let value): return try .insert(transformer(value))
        case .delete(let value): return try .delete(transformer(value))
        case .move(let values): return try .move(transformer(values.0), transformer(values.1))
        case .update(let value): return try .update(transformer(value))
        }
    }
}

extension Heckel.Diff: CustomStringConvertible {

    public var description: String {
        switch self {
        case .insert(let index): return "insert: \(index)"
        case .delete(let index): return "delete: \(index)"
        case .move(let indexes): return "move: \(indexes.0)-\(indexes.1)"
        case .update(let index): return "update: \(index)"
        }
    }
}

extension Heckel.Symbol: Then {}

extension Heckel.Symbol {

    var occursInBoth: Bool {
        return  oc != .zero && nc != .zero
    }
}
