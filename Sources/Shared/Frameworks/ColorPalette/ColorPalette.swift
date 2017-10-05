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
#if os(iOS)
        let bundle = Bundle(identifier: "hainguyen.mykit-iOS")
#elseif os(macOS)
        let bundle = Bundle(identifier: "hainguyen.mykit-macOS")
#endif
        let name = "ColorPalette", ext = "plist"

        guard let rawInfo = bundle?
            .url(forResource: name, withExtension: ext)
            .flatMap(NSArray.init(contentsOf:))
            else { fatalError("Unable to open \(name).\(ext)!") }

        self.storage = (rawInfo as? [String]) ?? []
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
