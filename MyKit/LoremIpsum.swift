//
//  LoremIpsum.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/28/15.
//
//

public final class LoremIpsum {

    private var sentences = [(string: String, wordCount: Int)]()

    public init?() {
        do {
            #if os(iOS)
                let identifier = "HaiNguyen.MyKitiOS"
            #elseif os(OSX)
                let identifier = "HaiNguyen.MyKitOSX"
            #endif

            guard let url = NSBundle(identifier: identifier)?.URLForResource("Lorem", withExtension: "strings"),
                case let lorem = try String(contentsOfURL: url) else { return nil }

            let range = lorem.startIndex..<lorem.endIndex
            let characters = NSCharacterSet.whitespaceAndNewlineCharacterSet()
            lorem.enumerateSubstringsInRange(range, options: .BySentences) { substring, _, _, _ in
                guard var string = substring else { return }
                string = string.stringByTrimmingCharactersInSet(characters)
                self.sentences.append((string, string.characters.split(" ").count))
            }
        } catch { print(error) }
    }

    public func arbitraryBySentences(count: Int, fromStart: Bool) -> String {
        let start = fromStart ? 0 : Int.arbitrary() % sentences.count - count
        let end = start.advancedBy(count)
        return sentences[start..<end].map { $0.string }.joinWithSeparator(" ")
    }

    public func arbitraryByWords(var count: Int) -> String {
        var index: Int
        repeat {
            index = Int.arbitrary() % sentences.count
        } while sentences[index].wordCount <= count

        let string = sentences[index].string
        var range = string.startIndex..<string.endIndex

        sentences[index].string.enumerateSubstringsInRange(range, options: .ByWords) { substring, subrange, _, stop in
            if substring?.isEmpty == true { return }
            range.endIndex = subrange.endIndex
            if --count == 0 { stop = true }
        }

        return string.substringWithRange(range)
    }

    public func arbitraryBySentences(range: Range<Int>, fromStart: Bool) -> String {
        return arbitraryBySentences(range.arbitrary(), fromStart: fromStart)
    }

    public func arbitraryByWords(range: Range<Int>) -> String {
        return arbitraryByWords(range.arbitrary())
    }
}