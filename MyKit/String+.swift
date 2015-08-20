//
//  String+.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/13/15.
//
//

public extension String {

    public func stringByRemovingSpecialCharacters() -> String {
        return self.stringByReplacingOccurrencesOfString("[\n\t]|[ ]+", withString: "", options: [.RegularExpressionSearch], range: nil)
    }

    mutating public func removeSpecialCharacters() {
        self = self.stringByReplacingOccurrencesOfString("[\n\t]|[ ]+", withString: "", options: [.RegularExpressionSearch], range: nil)
    }
}