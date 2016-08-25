/*
 * String+.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

public extension String {

    /// Produce a camel case string
    func camelcased() -> String {
        return NSCharacterSet(charactersInString: " -_")
            .andThen { self.componentsSeparatedByCharactersInSet($0) }
            .lazy
            .enumerate()
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

    /// Return a boolean whether string matches againsts the given pattern
    func isMatchedWith(pattern: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluateWithObject(self)
    }
}

public extension String {

    func toHexUInt() -> UInt? {
        guard self.isValidAs(.Hexadecimal) else { return nil }
        let scanner = NSScanner(string: self)
            .then { $0.scanLocation = 1 }

        guard let hex = scanner.scanHexUInt32() else { return nil }
        return UInt(hex)
    }
}

private extension String.Format {

    var pattern: String {
        switch self {
        case .IP: return [String](count: 4, repeatedValue: "([01]?\\d\\d?|2[0-4]\\d|25[0-5])").joinWithSeparator("\\.")
        case .Hexadecimal: return "#[0-9A-Fa-f]{2,6}"
        }
    }
}