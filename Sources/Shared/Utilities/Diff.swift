// 
// Diff.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

public enum Diff<T> {

    case insert(T)
    case delete(T)
    case update(T)
}

public extension Diff {

    func map<U>(_ transformer: (T) throws -> U) rethrows -> Diff<U> {
        switch self {
        case .delete(let value): return try .delete(transformer(value))
        case .insert(let value): return try .insert(transformer(value))
        case .update(let value): return try .update(transformer(value))
        }
    }

    func flatMap<U>(_ transfomer: (T) throws -> Diff<U>) rethrows -> Diff<U> {
        switch self {
        case .delete(let value): return try transfomer(value)
        case .insert(let value): return try transfomer(value)
        case .update(let value): return try transfomer(value)
        }
    }
}
