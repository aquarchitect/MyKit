/*
 * Scanner+.swift
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
