/*
 * LoremIpsum.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

/**
An LorumIpsum object generates random text at different length designed specifically for robust testing.

- throws: file corruption error.
*/
struct LoremIpsum: Collection {

    fileprivate let storage: [String]

    var startIndex: Int {
        return storage.startIndex
    }

    var endIndex: Int {
        return storage.endIndex
    }

    fileprivate init() {
        guard let url = Bundle.default?.url(forResource: "LoremIpsum", withExtension: "txt")
            else { fatalError("Unable to open source file!") }

        let lorem = try! String(contentsOf: url)
        let range = lorem.startIndex..<lorem.endIndex
        var storage = [String]()

        lorem.enumerateSubstrings(in: range, options: .bySentences) { substring, _, _, _ in
            let string = (substring ?? "")
                .replacingOccurrences(of: "\\n", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            if !string.isEmpty { storage.append(string) }
        }

        self.storage = storage
    }

    func index(after i: Int) -> Int {
        precondition(i != self.endIndex, "Out of bounds.")

        return i + 1
    }

    subscript(index: Int) -> String {
        return storage[index]
    }
}

extension LoremIpsum: CustomDebugStringConvertible {

    var debugDescription: String {
        return storage.joined(separator: " ")
    }
}

extension LoremIpsum {

    static var shared: LoremIpsum {
        struct Singleton { static var value = LoremIpsum() }
        return Singleton.value
    }
}
