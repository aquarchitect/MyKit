//
//  String+.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/13/15.
//
//

public extension String {

    /// Known format for string
    public enum Format { case IPAddress }

    /// Validate the receiver with format
    public func isValidatedAs(format: Format) -> Bool {
        return isMatchedWith(format.pattern)
    }

    public func isMatchedWith(pattern: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluateWithObject(self)
    }

    /// Produce a camel case string
    public var camelcaseString: String {
        return NSCharacterSet(charactersInString: " -_")
            .then { self.componentsSeparatedByCharactersInSet($0) }.enumerate()
            .map { $0 == 0 ? $1.lowercaseString : $1.capitalizedString }
            .joinWithSeparator("")
    }
}

private extension String.Format {

    var pattern: String {
        switch self {

        case .IPAddress: return [String](count: 4, repeatedValue:  "([01]?\\d\\d?|2[0-4]\\d|25[0-5])").joinWithSeparator("\\.")
        }
    }
}