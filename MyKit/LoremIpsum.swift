//
//  LoremIpsum.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/28/15.
//
//

public final class LoremIpsum {

    private var storage = ""

    private var maxCount: (sentences: Int, words: Int) = (0, 0)

    private var range: Range<String.CharacterView.Index> {
        return storage.startIndex..<storage.endIndex
    }

    public init() throws {
        guard let bundle = NSBundle.defaultBundle(),
            url = bundle.URLForResource("Lorem", withExtension: "strings")
            else { throw FileError.InvalidResourcePath }

        do {
            let lorem = try String(contentsOfURL: url)

            func maxCountForOption(option: NSStringEnumerationOptions) -> Int {
                var count = 0
                lorem.enumerateSubstringsInRange(self.range, options: option) { _, _, _, _ in count++ }
                return count
            }

            self.storage = lorem.stringByReplacingOccurrencesOfString("\\n", withString: "")
            self.maxCount = (maxCountForOption(.BySentences), maxCountForOption(.ByWords))
        } catch { throw FileError.UnableToDescryptTheFile }
    }

    public func arbitraryBySentences(var count: Int, fromStart flag: Bool) -> String {
        guard count < maxCount.sentences else { return storage }

        var starIndex = 0, string = ""

        if !flag {
            repeat { starIndex = Int.arbitrary() % maxCount.sentences
            } while starIndex + count > maxCount.sentences
        }

        storage.enumerateSubstringsInRange(range, options: .BySentences) { substring, _, _, stop in
            if starIndex == 0 {
                string += substring ?? ""

                if count > 1 { count-- }
                else { stop = true }
            } else { starIndex-- }
        }

        return string
    }

    public func arbitraryByWords(var count: Int, fromStart flag: Bool) -> String {
        guard count < maxCount.words else { return storage }

        var starIndex = 0, words = [String]()

        if !flag {
            repeat { starIndex = Int.arbitrary() % maxCount.words
            } while starIndex + count > maxCount.words
        }

        storage.enumerateSubstringsInRange(range, options: .ByWords) { substring, _, _, stop in
            if starIndex == 0 {
                words += [substring ?? ""]

                if count > 1 { count-- }
                else { stop = true }
            } else { starIndex-- }
        }

        return words.joinWithSeparator(" ").lowercaseString
    }

    public func arbitraryBySentences(range: Range<Int>, fromStart flag: Bool) -> String {
        return arbitraryBySentences(range.random(), fromStart: flag)
    }

    public func arbitraryByWords(range: Range<Int>, fromStart flag: Bool) -> String {
        return arbitraryByWords(range.random(), fromStart: flag)
    }
}

extension LoremIpsum: CustomDebugStringConvertible {

    public var debugDescription: String {
        return storage + "\n\nMax Count of Sentences - \(maxCount.sentences)" + "\nMax Count of Words - \(maxCount.words)"
    }
}