/*
 * Scanner+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

public extension Scanner {

    // MARK: String

    public func scan(characters: CharacterSet) -> String? {
        var result: NSString? = ""
        return self.scanCharacters(from: characters, into: &result) ? (result as? String) : nil
    }

    public func scan(upto characters: CharacterSet) -> String? {
        var result: NSString? = ""
        return self.scanUpToCharacters(from: characters, into: &result) ? (result as? String) : nil
    }

    public func scan(string: String) -> String? {
        var result: NSString? = ""
        return self.scanString(string, into: &result) ? result as? String : nil
    }

    public func scanUpTo(string: String) -> String? {
        var result: NSString? = ""
        return self.scanUpTo(string, into: &result) ? result as? String : nil
    }

    // MARK: Number

    public func scanDouble() -> Double? {
        var result: Double = 0
        return self.scanDouble(&result) ? result : nil
    }

    public func scanFloat() -> Float? {
        var result: Float = 0
        return self.scanFloat(&result) ? result : nil
    }

    public func scanInt() -> Int? {
        var result: Int = 0
        return self.scanInt(&result) ? result : nil
    }

    public func scanInt32() -> Int32? {
        var result: Int32 = 0
        return self.scanInt32(&result) ? result : nil
    }

    public func scanInt64() -> Int64? {
        var result: Int64 = 0
        return self.scanInt64(&result) ? result : nil
    }

    public func scanUInt64() -> UInt64? {
        var result: UInt64 = 0
        return self.scanUnsignedLongLong(&result) ? result : nil
    }

    public func scanDecimal() -> Decimal? {
        var result = Decimal()
        return self.scanDecimal(&result) ? result : nil
    }

    // MARK: Hext Number

    public func scanHexDouble() -> Double? {
        var result: Double = 0
        return self.scanHexDouble(&result) ? result : nil
    }

    public func scanHexFloat() -> Float? {
        var result: Float = 0
        return self.scanHexFloat(&result) ? result : nil
    }

    public func scanHexUInt32() -> UInt32? {
        var result: UInt32 = 0
        return self.scanHexInt32(&result) ? result : nil
    }

    public func scanHexUInt64() -> UInt64? {
        var result: UInt64 = 0
        return self.scanHexInt64(&result) ? result : nil
    }
}
