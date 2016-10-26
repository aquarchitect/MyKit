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
#if swift(>=3.0)
struct LoremIpsum: Collection {

    fileprivate let storage: [String]

    let startIndex = 0
    var endIndex: Int {
        return storage.count
    }

    fileprivate init() throws {
        let name = "LoremIpsum", ext = "txt"

        guard let url = Bundle.default?.url(forResource: name, withExtension: ext) else {
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
        struct Singleton {
            static var value = try! LoremIpsum()
        }

        return Singleton.value
    }
}
#else
struct LoremIpsum: CollectionType {

    private let storage: [String]

    let startIndex = 0
    var endIndex: Int {
        return storage.count
    }

    private init() throws {
        let name = "LoremIpsum", ext = "txt"

        guard let url = NSBundle.defaultBundle()?.URLForResource(name, withExtension: ext) else {
        enum FileIOError: ErrorType { case UnableToOpen(file: String) }
        throw FileIOError.UnableToOpen(file: "\(name).\(ext)")
        }

        let lorem = try String(contentsOfURL: url)
        let range = lorem.startIndex..<lorem.endIndex
        var storage = [String]()

        lorem.enumerateSubstringsInRange(range, options: .BySentences) { substring, _, _, _ in
            let string = (substring ?? "")
                .stringByReplacingOccurrencesOfString("\\n", withString: "")
                .stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())

            if !string.isEmpty { storage.append(string) }
        }

        self.storage = storage
    }

    subscript(index: Int) -> String {
        return storage[index]
    }
}

extension LoremIpsum: CustomDebugStringConvertible {

    var debugDescription: String {
        return storage.joinWithSeparator(" ")
    }
}

extension LoremIpsum {
    
    static func sharedInstance() -> LoremIpsum {
        struct Singleton {
            static var value = try! LoremIpsum()
        }
        
        return Singleton.value
    }
}
#endif
