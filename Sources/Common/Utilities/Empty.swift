// 
// Empty.swift
// MyKit
// 
// Created by Hai Nguyen on 12/16/16.
// Copyright (c) 2016 Hai Nguyen.
// 

/// The structure is a harmless meaningless error. 
/// The idea is to break asynchrous operation chaining.
public struct Empty: Error {

    fileprivate init() {}
}

public extension Empty {

    static var `default`: Empty {
        return .init()
    }
}

extension Empty: CustomStringConvertible {

    public var description: String {
        return "Harmless error"
    }
}
