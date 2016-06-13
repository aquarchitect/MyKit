/*
 * _LoremIpsum.swift
 * MyKit
 *
 * Copyright (c) 2015–2016 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

/**
An LorumIpsum object generates random text at different length designed specifically for robust testing.

- throws: file corruption error.
*/
final class _LoremIpsum: CollectionType {

    static let sharedInstance = try! _LoremIpsum()

    private let storage: [String]

    let startIndex = 0
    var endIndex: Int {
        return storage.count
    }

    private init() throws {
        let name = "LoremIpsum", ext = "txt"

        guard let url = NSBundle.defaultBundle?.URLForResource(name, withExtension: ext)
            else { throw Error.FailedToLocate(file: "\(name).\(ext)") }

        let lorem = try String(contentsOfURL: url)
        let range = lorem.startIndex..<lorem.endIndex
        var storage = [String]()

        lorem.enumerateSubstringsInRange(range, options: .BySentences) {
            var string = ($0.0 ?? "").stringByReplacingOccurrencesOfString("\\n", withString: "")
            string = string.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())

            guard !string.isEmpty else { return }
            storage.append(string)
        }

        self.storage = storage
    }

    subscript(index: Int) -> String {
        return storage[index]
    }
}

extension _LoremIpsum: CustomDebugStringConvertible {

    var debugDescription: String {
        return storage.joinWithSeparator(" ")
    }
}