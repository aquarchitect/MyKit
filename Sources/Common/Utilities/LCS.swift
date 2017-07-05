// 
// LCS.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

public enum LCS {

    public enum Diff<T> {

        case insert(T)
        case delete(T)
    }
}

public extension LCS.Diff {

    var value: T {
        switch self {
        case .delete(let value): return value
        case .insert(let value): return value
        }
    }

    var isDeleted: Bool {
        switch self {
        case .delete: return true
        default: return false
        }
    }

    var isInserted: Bool {
        switch self {
        case .insert: return true
        default: return false
        }
    }
}

public extension LCS.Diff {

    func map<U>(_ transformer: (T) throws -> U) rethrows -> LCS.Diff<U> {
        switch self {
        case .delete(let value): return try .delete(transformer(value))
        case .insert(let value): return try .insert(transformer(value))
        }
    }

    func flatMap<U>(_ transfomer: (T) throws -> LCS.Diff<U>) rethrows -> LCS.Diff<U> {
        switch self {
        case .delete(let value): return try transfomer(value)
        case .insert(let value): return try transfomer(value)
        }
    }
}
