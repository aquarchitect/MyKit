// 
// String+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import Foundation

public extension String {

    var fourCharCode: FourCharCode? {
        guard self.characters.count == 4 else { return nil }

        var result: FourCharCode = 0
        for stringView in self.utf16 {
            result = (result << 8) + FourCharCode(stringView)
        }

        return result
    }
}

#if !swift(>=4.0)
public extension String {

    /// Finds and returns the range of the first occurrence between given strings
    /// using regular expression option.
    func substring(between from: String, and to: String, range searchRange: Range<String.Index>? = nil, locale: Locale? = nil) -> String {
        return self.range(
            of: "(?<=\(from))[^\(to)]+",
            options: .regularExpression,
            range: searchRange,
            locale: locale
        ).map({ String(self[$0]) }) ?? ""
    }

    func substring(byOmittingSuffix suffix: String) -> String {
        return self.range(of: suffix)
            .map({ self[self.startIndex ..< $0.lowerBound] })
            ?? self
    }

    func substring(byOmittingPrefix prefix: String) -> String {
        return self.range(of: prefix)
            .map({ self[$0.upperBound ..< self.endIndex] })
            ?? self
    }
}
#endif

public extension String {

    /// Produce a camel case string
    var camelcased: String {
        return camelcased(with: nil)
    }

    func camelcased(with locale: Locale?) -> String {
        let characters = CharacterSet(charactersIn: " -_")
        return self.components(separatedBy: characters)
            .lazy
            .enumerated()
            .map { ($0 == 0 ? $1.lowercased : $1.capitalized)(locale) }
            .joined(separator: "")
    }
}

public extension String {

    @available(*, deprecated, message: "Prefer system format like autocapitalizationType")
    var capitalizedFirstWord: String {
        return capitalizedFirstWord(with: nil)
    }

    @available(*, deprecated, renamed: "capitalizedFirstWord")
    var capitalizedFirst: String {
        return capitalizedFirstWord
    }

    @available(*, deprecated, message: "Prefer system format like autocapitalizationType")
    func capitalizedFirstWord(with locale: Locale?) -> String {
        return self.range(of: " ").map {
            self.substring(to: $0.lowerBound)
                .capitalized(with: locale)
                + self.substring(from: $0.lowerBound)
            } ?? self
    }

    @available(*, deprecated, renamed: "capitalizedFirstWord(with:)")
    func capitalizedFirst(with locale: Locale?) -> String {
        return capitalizedFirstWord(with: locale)
    }
}

public extension String {

    /// Known format for string
    enum Format { case ip, hexadecimal, email }

    /// Validate the receiver with format
    func isValid(as format: Format) -> Bool {
        return isMatched(withPattern: format.pattern)
    }

    /// Return a boolean whether string matches againsts the given pattern
    func isMatched(withPattern pattern: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
}

public extension String {

    var hexUInt: UInt? {
        guard self.isValid(as: .hexadecimal) else { return nil }
        let scanner = Scanner(string: self)
            .then { $0.scanLocation = 1 }

        guard let hex = scanner.scanHexUInt32() else { return nil }
        return UInt(hex)
    }
}

private extension String.Format {

    var pattern: String {
        switch self {
        case .ip:
            return Array(
                repeating: "([01]?\\d\\d?|2[0-4]\\d|25[0-5])",
                count: 4
            ).joined(separator: "\\.")
        case .hexadecimal:
            return "#[0-9A-Fa-f]{2,6}"
        case .email:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        }
    }
}
