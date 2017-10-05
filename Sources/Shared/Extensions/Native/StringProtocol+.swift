//
//  StringProtocol+.swift
//  MyKit
//
//  Created by Hai Nguyen on 10/2/17.
//

import Foundation

#if swift(>=4.0)
public extension StringProtocol where Index == String.Index {
    
    /// Finds and returns the range of the first occurrence between given strings
    /// using regular expression option.
    func substring<T>(between from: T, and to: T, range searchRange: Range<String.Index>? = nil, locale: Locale? = nil) -> String where T: StringProtocol {
        return self.range(
            of: "(?<=\(from))[^\(to)]+",
            options: .regularExpression,
            range: searchRange,
            locale: locale
        ).map({ String(self[$0]) }) ?? ""
    }
    
    func substring<T>(byOmittingSuffix suffix: T) -> String where T: StringProtocol {
        return self.range(of: suffix)
            .map({ self[self.startIndex ..< $0.lowerBound] })
            .map(String.init) ?? String(self)
    }
    
    func substring<T>(byOmittingPrefix prefix: T) -> String where T: StringProtocol{
        return self.range(of: prefix)
            .map({ self[$0.upperBound ..< self.endIndex] })
            .map(String.init) ?? String(self)
    }
}
#endif
