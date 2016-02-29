//
//  LoremIpsum.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/28/15.
//
//

/**

An LorumIpsum object generates random text at different length designed specifically for testing.

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
        guard let bundle = NSBundle.defaultBundle(),
            url = bundle.URLForResource("LoremIpsum", withExtension: "txt")
            else { return }

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
        return "\(storage)"
    }
}