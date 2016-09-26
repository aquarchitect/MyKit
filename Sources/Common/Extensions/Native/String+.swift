/*
 * String+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

public extension String {

    /// Produce a camel case string
    func camelcased() -> String {
        return (CharacterSet.init(charactersIn:) >>> self.components)(" -_")
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

    func toHexUInt() -> UInt? {
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
        case .ip: return [String](repeating: "([01]?\\d\\d?|2[0-4]\\d|25[0-5])", count: 4).joined(separator: "\\.")
        case .hexadecimal: return "#[0-9A-Fa-f]{2,6}"
        }
    }
}
