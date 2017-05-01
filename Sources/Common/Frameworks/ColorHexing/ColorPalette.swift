// 
// ColorPalette.swift
// MyKit
// 
// Created by Hai Nguyen on 11/13/16.
// Copyright (c) 2016 Hai Nguyen.
// 

import Foundation

struct ColorPalette: Collection {

    static let shared = ColorPalette()

    // MARK: Initialization

    fileprivate let storage: [String]

    var startIndex: Int {
        return storage.startIndex
    }

    var endIndex: Int {
        return storage.endIndex
    }

    // MARK: Initialization

    fileprivate init() {
        guard let url = Bundle.default?.url(forResource: "ColorPalette", withExtension: "plist")
            else { fatalError("Unable to open source file!") }

        self.storage = (NSArray(contentsOf: url) ?? []).flatMap { $0 as? String }
    }

    // MARK: System Methods

    func index(after i: Int) -> Int {
        precondition(i < self.endIndex, "Out of bounds.")
        
        return i + 1
    }

    subscript(index: Int) -> String {
        return storage[index]
    }
}
