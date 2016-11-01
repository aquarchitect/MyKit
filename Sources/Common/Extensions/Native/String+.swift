/*
 * String+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

public extension String {

    var fourCharCode: FourCharCode? {
        guard self.characters.count == 4 else { return nil }
        return self.utf16.reduce(0) { ($0 << 8) + FourCharCode($1) }
    }
}

public extension String {

    /// Produce a camel case string
    func camelcased() -> String {
#if swift(>=3.0)
        return (CharacterSet.init(charactersIn:) >>> self.components)(" -_")
            .lazy
            .enumerated()
            .map { $0 == 0 ? $1.lowercased() : $1.capitalized }
            .joined(separator: "")
#else
        return (NSCharacterSet.init(charactersInString:) >>> self.componentsSeparatedByCharactersInSet)(" -_")
            .lazy
            .enumerate()
            .map { $0 == 0 ? $1.lowercaseString : $1.capitalizedString }
            .joinWithSeparator("")
#endif
    }
}

public extension String {

    /// Known format for string
#if swift(>=3.0)
    enum Format { case ip, hexadecimal }
#else
    enum Format { case IP, Hexadecimal }
#endif

    /// Validate the receiver with format
#if swift(>=3.0)
    func isValidAs(_ format: Format) -> Bool {
        return isMatched(withPattern: format.pattern)
    }
#else
    func isValidAsFormat(format: Format) -> Bool {
        return isMatchedWithPattern(format.pattern)
    }
#endif

    /// Return a boolean whether string matches againsts the given pattern
#if swift(>=3.0)
    func isMatched(withPattern pattern: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
#else
    func isMatchedWithPattern(pattern: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluateWithObject(self)
    }
#endif
}

public extension String {

#if swift(>=3.0)
    var hexUInt: UInt? {
        guard self.isValidAs(.hexadecimal) else { return nil }
        let scanner = Scanner(string: self)
            .then { $0.scanLocation = 1 }

        guard let hex = scanner.scanHexUInt32() else { return nil }
        return UInt(hex)
    }
#else
    func toHexUInt() -> UInt? {
        guard self.isValidAsFormat(.Hexadecimal) else { return nil }
        let scanner = NSScanner(string: self)
            .then { $0.scanLocation = 1 }

        guard let hex = scanner.scanHexUInt32() else { return nil }
        return UInt(hex)
    }
#endif
}

private extension String.Format {

    var pattern: String {
#if swift(>=3.0)
        switch self {
        case .ip: return [String](repeating: "([01]?\\d\\d?|2[0-4]\\d|25[0-5])", count: 4).joined(separator: "\\.")
        case .hexadecimal: return "#[0-9A-Fa-f]{2,6}"
        }
#else
        switch self {
        case .IP: return [String](count: 4, repeatedValue: "([01]?\\d\\d?|2[0-4]\\d|25[0-5])").joinWithSeparator("\\.")
        case .Hexadecimal: return "#[0-9A-Fa-f]{2,6}"
        }
#endif
    }
}
