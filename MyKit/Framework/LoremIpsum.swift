//
//  LoremIpsum.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/28/15.
//
//

/**

LorumIpsum is a random text generator designed specifically for testing; therefore, a output string at different will make the test much more efficently.

- throws: It will throw file error in case of file corruption.

*/
public final class LoremIpsum: CollectionType {

    private var storage: [String] = []

    public let startIndex = 0
    public var endIndex: Int {
        return storage.count
    }

    public init?() throws {
        guard let bundle = NSBundle.defaultBundle(),
            url = bundle.URLForResource("LoremIpsum", withExtension: "strings")
            else { return nil }

        let lorem = try String(contentsOfURL: url)
        let range = lorem.startIndex..<lorem.endIndex

        lorem.enumerateSubstringsInRange(range, options: .BySentences) {
            var string = ($0.0 ?? "").stringByReplacingOccurrencesOfString("\\n", withString: "")
            string = string.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())

            self.storage.append(string ?? "")
        }
    }

    public subscript(index: Int) -> String {
        return storage[index]
    }
}