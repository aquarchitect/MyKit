//
//  String+.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/13/15.
//
//

import Foundation

public extension String {

    /// Produce a camel case string
    func camelcased() -> String {
        return NSCharacterSet(charactersInString: " -_")
            .then { self.componentsSeparatedByCharactersInSet($0) }.enumerate()
            .map { $0 == 0 ? $1.lowercaseString : $1.capitalizedString }
            .joinWithSeparator("")
    }
}

public extension String {

    /// Known format for string
    enum Format { case IP, Hexadecimal }

    /// Validate the receiver with format
    func isValidAs(format: Format) -> Bool {
        return isMatchedWith(format.pattern)
    }

    func isMatchedWith(pattern: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluateWithObject(self)
    }
}

private extension String.Format {

    var pattern: String {
        switch self {
        case .IP: return [String](count: 4, repeatedValue: "([01]?\\d\\d?|2[0-4]\\d|25[0-5])").joinWithSeparator("\\.")
        case .Hexadecimal: return "#[0-9A-F]{2,6}"
        }
    }
}