/*
 * ColorPalette.swift
 * MyKit
 *
 * Created by Hai Nguyen on 11/13/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

import Foundation

struct ColorPalette: Collection {

    fileprivate let storage: [String]

    var startIndex: Int {
        return storage.startIndex
    }

    var endIndex: Int {
        return storage.endIndex
    }

    fileprivate init() {
        guard let url = Bundle.default?.url(forResource: "ColorPalette", withExtension: "plist")
            else { fatalError("Unable to open source file!") }

        self.storage = (NSArray(contentsOf: url) ?? []).flatMap { $0 as? String }
    }

    func index(after i: Int) -> Int {
        precondition(i != self.endIndex, "Out of bounds.")

        return i + 1
    }

    subscript(index: Int) -> String {
        return storage[index]
    }
}

extension ColorPalette {

    static var shared: ColorPalette {
        struct Singleton { static var value = ColorPalette() }
        return Singleton.value
    }
}
