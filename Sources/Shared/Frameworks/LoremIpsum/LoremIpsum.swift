// 
// LoremIpsum.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import Foundation

/// A LorumIpsum random text generator; its main purpose
/// is for testing with different text lenght.
public struct LoremIpsum: Collection {

    static public let shared = LoremIpsum()

    // MARK: Properties

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
        let name = "LoremIpsum", ext = "txt"

        guard let lorem = try! bundle?
            .url(forResource: name, withExtension: ext)
            .flatMap(String.init(contentsOf:))
            else { fatalError("Unable to open \(name).\(ext)!") }

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

    // MARK: System Methods

    public func index(after i: Int) -> Int {
        precondition(i < endIndex, "Out of bounds.")

        return i + 1
    }

    public subscript(index: Int) -> String {
        return storage[index]
    }
}

extension LoremIpsum: CustomDebugStringConvertible {

    public var debugDescription: String {
        return storage.joined(separator: "\n")
    }
}
