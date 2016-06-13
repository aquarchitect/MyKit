/*
 * NSMutableAttributedString+.swift
 * MyKit
 *
 * Copyright (c) 2015–2016 Hai Nguyen
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
#elseif os(OSX)
import AppKit
#endif

private extension NSMutableAttributedString {

    var range: NSRange { return NSMakeRange(0, self.length) }

    func _addFont(value: AnyObject?, _ range: NSRange?) {
        guard let _value = value else { return }
        self.addAttribute(NSFontAttributeName, value: _value, range: range ?? self.range)
    }

    func _addColor(value: AnyObject?, _ range: NSRange?) {
        guard let _value = value else { return }
        self.addAttribute(NSForegroundColorAttributeName, value: _value, range: range ?? self.range)
    }
}

#if os(iOS)
public extension NSMutableAttributedString {

    func addFont(value: UIFont?, toRange range: NSRange? = nil) {
        self._addFont(value, range)
    }

    func addColor(value: UIColor?, toRange range: NSRange? = nil) {
        self._addColor(value, range)
    }
}
#elseif os(OSX)
public extension NSMutableAttributedString {

    func addFont(value: NSFont?, toRange range: NSRange? = nil) {
        self._addFont(value, range)
    }

    func addColor(value: NSColor?, toRange range: NSRange? = nil) {
        self._addColor(value, range)
    }
}
#endif

public extension NSMutableAttributedString {

    func addAlignment(value: NSTextAlignment, toRange range: NSRange? = nil) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = value

        self.addParagraph(paragraph, toRange: range)
    }

    func addParagraph(value: NSParagraphStyle, toRange range: NSRange? = nil) {
        self.addAttribute(NSParagraphStyleAttributeName, value: value, range: range ?? self.range)
    }

    func addBaseline(value: Float, toRange range: NSRange? = nil) {
        self.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(float: value), range: range ?? self.range)
    }

    func addKern(value: Float, toRange range: NSRange? = nil) {
        self.addAttribute(NSKernAttributeName, value: NSNumber(float: value), range: range ?? self.range)
    }
}

public func + (lhs: NSMutableAttributedString, rhs: NSMutableAttributedString) -> NSMutableAttributedString {
    return NSMutableAttributedString(attributedString: lhs)
        .then { $0.appendAttributedString(rhs) }
}