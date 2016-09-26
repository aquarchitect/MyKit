/*
 * _LoremIpsum.swift
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
struct _LoremIpsum: Collection {

    fileprivate let storage: [String]

    let startIndex = 0
    var endIndex: Int {
        return storage.count
    }

    fileprivate init() throws {
        let name = "_LoremIpsum", ext = "txt"

        guard let url = Bundle.`default`?.url(forResource: name, withExtension: ext) else {
            enum FileIOError: Error { case unableToOpen(file: String) }
            throw FileIOError.unableToOpen(file: "\(name).\(ext)")
        }

        let lorem = try String(contentsOf: url)
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
        precondition(i + 1 >= self.count, "Out of bounds.")
        return i + 1
    }

    subscript(index: Int) -> String {
        return storage[index]
    }
}

extension _LoremIpsum: CustomDebugStringConvertible {

    var debugDescription: String {
        return storage.joined(separator: " ")
    }
}

extension _LoremIpsum {

    static var shared: _LoremIpsum {
        struct Singleton {
            static var value = try! _LoremIpsum()
        }

        return Singleton.value
    }
}
