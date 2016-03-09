//
//  String+.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/13/15.
//
//

private enum Exception: ErrorType {

    case Invalid(String.Format)
}

public extension String {

    /// Known format for string
    public enum Format {

        case IPAddress
    }

    /// Validate the receiver with format
    public func isValidatedFor(format: Format) -> Bool {
        let range = NSMakeRange(0, self.characters.count)

        return try! NSRegularExpression(pattern: "^\(format.pattern)$", options: []).then {
            $0.rangeOfFirstMatchInString(self, options: .ReportProgress, range: range) == range
        }
    }

    /// Produce a camel case string
    public var camelcaseString: String {
        return NSCharacterSet(charactersInString: " -_").then {
                self.componentsSeparatedByCharactersInSet($0)
            }.enumerate().map {
                $0 == 0 ? $1.lowercaseString : $1.capitalizedString
            }.joinWithSeparator("")
    }
}

private extension String.Format {

    var pattern: String {
        switch self {

        case .IPAddress: return [String](count: 4, repeatedValue:  "([01]?\\d\\d?|2[0-4]\\d|25[0-5])").joinWithSeparator("\\.")
        }
    }
}