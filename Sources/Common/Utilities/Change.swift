/*
 * Change.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

/// _Change_ represents a difference of LCS algorithm.
public enum Change<T> {

    case insert(T)
    case delete(T)
}

// MARK: - Attributes

public extension Change {

    var value: T {
        switch self {
        case .delete(let value): return value
        case .insert(let value): return value
        }
    }

    var isDeleted: Bool {
        switch self {
        case .delete(_): return true
        default: return false
        }
    }

    var isInserted: Bool {
        switch self {
        case .insert(_): return true
        default: return false
        }
    }
}

// MARK: - Transformation

public extension Change {

#if swift(>=3.0)
    func map<U>(_ transform: (T) throws -> U) rethrows -> Change<U> {
        switch self {
        case .delete(let value): return try .delete(transform(value))
        case .insert(let value): return try .insert(transform(value))
        }
    }
#else
    func map<U>(transform: (T) throws -> U) rethrows -> Change<U> {
        switch self {
        case .delete(let value): return try .delete(transform(value))
        case .insert(let value): return try .insert(transform(value))
        }
    }
#endif
}
