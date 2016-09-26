/*
 * NSMutableAttributedString+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
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
