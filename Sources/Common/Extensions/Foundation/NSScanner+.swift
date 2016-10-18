/*
 * NSScanner+.swift
 * MyKit
 *
 * Created by Hai Nguyen
 * Copyright (c) 2015 Hai Nguyen
 */

import Foundation

#if swift(>=3.0)
#else
public extension NSScanner {

    // MARK: String

    public func scanCharactersFrom(set: NSCharacterSet) -> String? {
        var result: NSString? = ""
        return self.scanCharactersFromSet(set, intoString: &result) ? result as? String : nil
    }

    public func scanUpToCharactersFrom(set: NSCharacterSet) -> String? {
        var result: NSString? = ""
        return self.scanUpToCharactersFromSet(set, intoString: &result) ? result as? String : nil
    }

    public func scanString(string: String) -> String? {
        var result: NSString? = ""
        return self.scanString(string, intoString: &result) ? result as? String : nil
    }

    public func scanUpToString(string: String) -> String? {
        var result: NSString? = ""
        return self.scanUpToString(string, intoString: &result) ? result as? String : nil
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
        return self.scanInteger(&result) ? result : nil
    }

    public func scanInt32() -> Int32? {
        var result: Int32 = 0
        return self.scanInt(&result) ? result : nil
    }

    public func scanInt64() -> Int64? {
        var result: Int64 = 0
        return self.scanLongLong(&result) ? result : nil
    }

    public func scanUInt64() -> UInt64? {
        var result: UInt64 = 0
        return self.scanUnsignedLongLong(&result) ? result : nil
    }

    public func scanDecimal() -> NSDecimal? {
        var result = NSDecimal()
        return self.scanDecimal(&result) ? result : nil
    }

    // MARK: Hex Number

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
        return self.scanHexInt(&result) ? result : nil
    }

    public func scanHexUInt64() -> UInt64? {
        var result: UInt64 = 0
        return self.scanHexLongLong(&result) ? result : nil
    }
}
#endif
