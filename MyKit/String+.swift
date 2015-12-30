//
//  String+.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/13/15.
//
//

public extension String {

    public func stringByRemovingSpecialCharacters() -> String {
        return self.stringByReplacingOccurrencesOfString("[\n\t]|[ ]+", withString: "", options: .RegularExpressionSearch, range: nil)
    }

    mutating public func removeSpecialCharacters() {
        self = self.stringByReplacingOccurrencesOfString("[\n\t]|[ ]+", withString: "", options: .RegularExpressionSearch, range: nil)
    }

    public func validateForIPAddress() -> Bool {
        let component = "([01]?\\d\\d?|2[0-4]\\d|25[0-5])"
        let pattern = [String](count: 4, repeatedValue: component).joinWithSeparator("\\.")

        guard let regex = try? NSRegularExpression(pattern: "^\(pattern)$", options: []) else { return false }
        let range = NSMakeRange(0, self.characters.count)

        return regex.rangeOfFirstMatchInString(self, options: .ReportProgress, range: range) == range
    }
}