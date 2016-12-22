/*
 * String+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

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
    func camelcased() -> String {
        return (self.components(separatedBy:) • CharacterSet.init(charactersIn:))(" -_")
            .lazy
            .enumerated()
            .map { $0 == 0 ? $1.lowercased() : $1.capitalized }
            .joined(separator: "")
    }
}

public extension String {

    /// Known format for string
    enum Format { case ip, hexadecimal }

    /// Validate the receiver with format
    func isValidAs(_ format: Format) -> Bool {
        return isMatched(withPattern: format.pattern)
    }

    /// Return a boolean whether string matches againsts the given pattern
    func isMatched(withPattern pattern: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
}

public extension String {

    var hexUInt: UInt? {
        guard self.isValidAs(.hexadecimal) else { return nil }
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
            return Array(repeating: "([01]?\\d\\d?|2[0-4]\\d|25[0-5])", count: 4)
                .joined(separator: "\\.")
        case .hexadecimal:
            return "#[0-9A-Fa-f]{2,6}"
        }
    }
}
