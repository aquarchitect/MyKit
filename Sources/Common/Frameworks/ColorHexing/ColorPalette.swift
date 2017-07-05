// 
// ColorPalette.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import Foundation

public struct ColorPalette: Collection {

    static public let shared = ColorPalette()

    // MARK: Initialization

    fileprivate let storage: [String]

    public var startIndex: Int {
        return storage.startIndex
    }

    public var endIndex: Int {
        return storage.endIndex
    }

    // MARK: Initialization

    fileprivate init() {
        guard let url = Bundle.default?.url(forResource: "ColorPalette", withExtension: "plist")
            else { fatalError("Unable to open source file!") }

        self.storage = (NSArray(contentsOf: url) as? [String]) ?? []
    }

    // MARK: System Methods

    public func index(after i: Int) -> Int {
        precondition(i < self.endIndex, "Out of bounds.")
        
        return i + 1
    }

    public subscript(index: Int) -> String {
        return storage[index]
    }
}
