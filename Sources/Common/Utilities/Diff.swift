// 
// Diff.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

/// _Diff_ represents a difference of LCS algorithm.
public enum Diff<T> {

    case insert(T)
    case delete(T)
}

// MARK: - Attributes

public extension Diff {

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

public extension Diff {

    func map<U>(_ transformer: (T) throws -> U) rethrows -> Diff<U> {
        switch self {
        case .delete(let value): return try .delete(transformer(value))
        case .insert(let value): return try .insert(transformer(value))
        }
    }
}
