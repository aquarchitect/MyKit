//
//  LoremIpsum.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/28/15.
//
//

/**
An LorumIpsum object generates random text at different length designed specifically for robust testing.

- throws: file corruption error.
*/
public final class LoremIpsum: CollectionType {

    public static let sharedInstance = try? LoremIpsum()

    private var storage: [String] = []

    public let startIndex = 0
    public var endIndex: Int {
        return storage.count
    }

    init() throws {
        let name = "LoremIpsum", ext = "txt"

        guard let url = NSBundle.defaultBundle?.URLForResource(name, withExtension: ext)
            else { throw CommonError.FailedToLocate(file: "\(name).\(ext)") }

        let lorem = try String(contentsOfURL: url)
        let range = lorem.startIndex..<lorem.endIndex

        lorem.enumerateSubstringsInRange(range, options: .BySentences) {
            var string = ($0.0 ?? "").stringByReplacingOccurrencesOfString("\\n", withString: "")
            string = string.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())

            guard !string.isEmpty else { return }
            self.storage.append(string)
        }
    }

    public subscript(index: Int) -> String {
        return storage[index]
    }
}

extension LoremIpsum: CustomDebugStringConvertible {

    public var debugDescription: String {
        return storage.joinWithSeparator(" ")
    }
}