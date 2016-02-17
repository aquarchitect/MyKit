//
//  LoremIpsum.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/28/15.
//
//

public final class LoremIpsum {

    private var storage = ""

    private var numberOfSentences = 0

    private var range: Range<String.CharacterView.Index> {
        return storage.startIndex..<storage.endIndex
    }

    public init() throws {
        guard let bundle = NSBundle.defaultBundle(),
            url = bundle.URLForResource("Lorem", withExtension: "strings")
            else { throw FileError.InvalidResourcePath }

        do {
            let lorem = try String(contentsOfURL: url)

            var count = 0
            lorem.enumerateSubstringsInRange(self.range, options: .BySentences) { _, _, _, _ in count += 1}

            self.storage = lorem.stringByReplacingOccurrencesOfString("\\n", withString: "")
            self.numberOfSentences = count
        } catch { throw FileError.UnableToDecryptTheFile }
    }

    public func generatedBySentences(count: Int, fromStart flag: Bool) -> String {
        assert(count <= numberOfSentences, "Exceed the limit of sentences.")

        var index = flag ? 0 : ((0..<numberOfSentences).random ?? 0)
        var string = "", _count = count

        storage.enumerateSubstringsInRange(range, options: .BySentences) { substring, _, _, stop in
            if index != 0 { index -= 1; return  }

            string += substring ?? ""

            if _count > 1 { _count -= 1 }
            else { stop = true }
        }

        return string
    }
}

extension LoremIpsum: CustomDebugStringConvertible {

    public var debugDescription: String {
        return storage + "\n\nMax Count of Sentences - \(numberOfSentences)"
    }
}