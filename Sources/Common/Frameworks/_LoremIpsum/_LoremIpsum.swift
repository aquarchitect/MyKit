/*
 * _LoremIpsum.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
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
