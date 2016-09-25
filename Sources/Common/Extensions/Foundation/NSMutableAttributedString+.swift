/*
 * NSMutableAttributedString+.swift
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

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

fileprivate extension NSMutableAttributedString {

    var range: NSRange { return NSMakeRange(0, self.length) }

    func _add(font: AnyObject?, to range: NSRange?) {
        self.addAttribute(NSFontAttributeName, value: font, range: range ?? self.range)
    }

    func _add(color: AnyObject?, to range: NSRange?) {
        self.addAttribute(NSForegroundColorAttributeName, value: color, range: range ?? self.range)
    }
}

#if os(iOS)
public extension NSMutableAttributedString {

    func add(font: UIFont?, to range: NSRange? = nil) {
        self._add(font: font, to: range)
    }

    func add(color: UIColor?, to range: NSRange? = nil) {
        self._add(color: color, to: range)
    }
}
#elseif os(macOS)
public extension NSMutableAttributedString {

    func add(font: NSFont?, to range: NSRange? = nil) {
        self._add(font: font, to: range)
    }

    func add(color: NSColor?, to range: NSRange? = nil) {
        self._add(color: color, to: range)
    }
}
#endif

public extension NSMutableAttributedString {

    func add(alignment: NSTextAlignment, to range: NSRange? = nil) {
        NSMutableParagraphStyle()
            .then { $0.alignment = alignment }
            .then { self.add(paragraph: $0, to: range) }
    }

    func add(paragraph: NSParagraphStyle, to range: NSRange? = nil) {
        self.addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: range ?? self.range)
    }

    func add(baseline: Float, to range: NSRange? = nil) {
        self.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(value: baseline), range: range ?? self.range)
    }

    func add(kern: Float, to range: NSRange? = nil) {
        self.addAttribute(NSKernAttributeName, value: NSNumber(value: kern), range: range ?? self.range)
    }
}

public func + (lhs: NSMutableAttributedString, rhs: NSMutableAttributedString) -> NSMutableAttributedString {
    return NSMutableAttributedString(attributedString: lhs).then { $0.append(rhs) }
}
