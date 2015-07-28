//
//  String+.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/26/15.
//
//

public extension String {

    public mutating func removeStringBetween(open open: String, end: String) {
        while let openRange = self.rangeOfString(open), endRange = self.rangeOfString(end) {
            self.removeRange(openRange.startIndex..<endRange.endIndex)
        }
    }

    public mutating func replaceOccurencesOfString(target: String, withString replacement: String, options: NSStringCompareOptions = []) {
        self = self.stringByReplacingOccurrencesOfString(target, withString: replacement, options: [], range: nil)
    }
}