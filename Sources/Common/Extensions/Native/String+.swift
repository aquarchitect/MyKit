// 
// String+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import Foundation

public extension String {

    func substring(between from: String, and to: String) -> String {
        return Optional("(?<=\(from))[^\(to)]+")
            .flatMap { self.range(of: $0, options: .regularExpression, range: nil, locale: nil) }
            .map { self[$0] }
            ?? ""
    }
}

public extension String {

    var fourCharCode: FourCharCode? {
        guard self.characters.count == 4 else { return nil }
        return self.utf16.reduce(0) { ($0 << 8) + FourCharCode($1) }
    }
}

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

    var capitalizedFirst: String {
        return capitalizedFirst(with: nil)
    }

    func capitalizedFirst(with locale: Locale?) -> String {
        let index = self.index(after: self.startIndex)

        return self.substring(to: index)
            .capitalized(with: locale)
            + self.substring(from: index)
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
