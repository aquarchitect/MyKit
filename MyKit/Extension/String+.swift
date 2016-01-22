//
//  String+.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/13/15.
//
//

public extension String {

    /// Known format for string
    public enum Format {

        case IPAddress
    }

    /// Validate the receiver with format
    public func validateFormat(format: Format) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: "^\(format.pattern)$", options: []) else { return false }
        let range = NSMakeRange(0, self.characters.count)

        return regex.rangeOfFirstMatchInString(self, options: .ReportProgress, range: range) == range
    }
}

private extension String.Format {

    var pattern: String {
        let component = "([01]?\\d\\d?|2[0-4]\\d|25[0-5])"
        return [String](count: 4, repeatedValue: component).joinWithSeparator("\\.")
    }
}