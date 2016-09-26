/*
 * Change.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

public enum Change<T> {

    case insert(T)
    case delete(T)
}

public extension Change {

    var value: T {
        switch self {
        case .delete(let value): return value
        case .insert(let value): return value
        }
    }

    func then<U>(_ transform: (T) throws -> U) rethrows -> Change<U> {
        switch self {
        case .delete(let value): return try .delete(transform(value))
        case .insert(let value): return try .insert(transform(value))
        }
    }
}

public extension Change {

    var isDelete: Bool {
        switch self {
        case .delete(_): return true
        default: return false
        }
    }

    var isInsert: Bool {
        switch self {
        case .insert(_): return true
        default: return false
        }
    }
}
