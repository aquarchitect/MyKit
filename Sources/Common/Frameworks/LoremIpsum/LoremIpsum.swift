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
final class LoremIpsum: CollectionType {

    static let sharedInstance = try! LoremIpsum()

    private let storage: [String]

    let startIndex = 0
    var endIndex: Int {
        return storage.count
    }

    private init() throws {
        let name = "LoremIpsum", ext = "txt"

        guard let url = NSBundle.defaultBundle?.URLForResource(name, withExtension: ext)
            else { throw CommonError.FailedToLocateFile("\(name).\(ext)") }

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

extension LoremIpsum: CustomDebugStringConvertible {

    var debugDescription: String {
        return storage.joinWithSeparator(" ")
    }
}