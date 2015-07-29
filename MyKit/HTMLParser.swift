//
//  HTMLParser.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/27/15.
//
//

import Foundation

public struct HTMLParser {

    public static func h1(string: String) -> String {
        return tag("h1", string: string)
    }

    public static func h2(string: String) -> String {
        return tag("h2", string: string)
    }

    public static func h3(string: String) -> String {
        return tag("h3", string: string)
    }

    public static func a(string: String, _ link: String) -> String {
        return tag("a", string: string, attributes: "href=\(link)")
    }

    public static func p(string: String) -> String {
        return tag("p", string: string)
    }

    public static func li(string: String) -> String {
        return tag("li", string: string)
    }

    public static func span(string: String) -> String {
        return tag("span", string: string)
    }

    public static func tag(name: String, string: String, attributes: String...) -> String {
        let open = " ".join([name] + attributes)
        return "<\(open)>" + string + "</\(name)>"
    }

    public static func removeCommentAndWhitespace(var string: String) throws -> String {
        while let openRange = string.rangeOfString("<!--"), endRange = string.rangeOfString("-->") {
            string.removeRange(openRange.startIndex..<endRange.endIndex)
        }

        let range = NSMakeRange(0, string.characters.count)
        let regex = try NSRegularExpression(pattern: "([\n]+|[ \n]+ )", options: [])
        string = regex.stringByReplacingMatchesInString(string, options: [], range: range, withTemplate: "")

        return string
    }
}