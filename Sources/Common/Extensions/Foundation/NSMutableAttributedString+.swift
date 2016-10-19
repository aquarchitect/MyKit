/*
 * NSMutableAttributedString+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

extension NSMutableAttributedString {

    var range: NSRange { return NSMakeRange(0, self.length) }
#if swift(>=3.0)
    func _addFont(_ font: Any, to range: NSRange?) {
        self.addAttribute(NSFontAttributeName,
                          value: font,
                          range: range ?? self.range)
    }

    func _addColor(_ color: Any, to range: NSRange?) {
        self.addAttribute(NSForegroundColorAttributeName,
                          value: color,
                          range: range ?? self.range)
    }
#else
    func _addFont(font: AnyObject, to range: NSRange?) {
        self.addAttribute(NSFontAttributeName,
                          value: font,
                          range: range ?? self.range)
    }

    func _addColor(color: AnyObject, to range: NSRange?) {
        self.addAttribute(NSForegroundColorAttributeName,
                          value: color,
                          range: range ?? self.range)
    }
#endif
}

#if os(iOS)
public extension NSMutableAttributedString {

#if swift(>=3.0)
    func addFont(_ font: UIFont?, to range: NSRange? = nil) {
        font.flatMap { self._addFont($0, to: range) }
    }

    func addColor(_ color: UIColor?, to range: NSRange? = nil) {
        color.flatMap { self._addColor($0, to: range) }
    }
#else
    func addFont(font: UIFont?, to range: NSRange? = nil) {
        _ = font.flatMap { self._addFont($0, to: range) }
    }

    func addColor(color: UIColor?, to range: NSRange? = nil) {
        _ = color.flatMap { self._addColor($0, to: range) }
    }
#endif
}
#elseif os(OSX)
public extension NSMutableAttributedString {

#if swift(>=3.0)
    func addFont(_ font: NSFont?, to range: NSRange? = nil) {
        font.flatMap { self._addFont($0, to: range) }
    }

    func addColor(_ color: NSColor?, to range: NSRange? = nil) {
        color.flatMap { self._addColor($0, to: range) }
    }
#else
    func addFont(font: NSFont?, to range: NSRange? = nil) {
        _ = font.flatMap { self._addFont($0, to: range) }
    }

    func addColor(color: NSColor?, to range: NSRange? = nil) {
        _ = color.flatMap { self._addColor($0, to: range) }
    }
#endif
}
#endif

public extension NSMutableAttributedString {

#if swift(>=3.0)
    func addAlignment(_ alignment: NSTextAlignment, to range: NSRange? = nil) {
        NSMutableParagraphStyle()
            .then { $0.alignment = alignment }
            .then { self.addParagraph($0, to: range) }
    }

    func addParagraph(_ paragraph: NSParagraphStyle, to range: NSRange? = nil) {
        self.addAttribute(NSParagraphStyleAttributeName,
                          value: paragraph,
                          range: range ?? self.range)
    }

    func addBaseline(_ baseline: Float, to range: NSRange? = nil) {
        self.addAttribute(NSBaselineOffsetAttributeName,
                          value: NSNumber(value: baseline),
                          range: range ?? self.range)
    }

    func addKern(_ kern: Float, to range: NSRange? = nil) {
        self.addAttribute(NSKernAttributeName,
                          value: NSNumber(value: kern),
                          range: range ?? self.range)
    }
#else
    func addAlignment(alignment: NSTextAlignment, to range: NSRange? = nil) {
        NSMutableParagraphStyle()
            .then { $0.alignment = alignment }
            .then { self.addParagraph($0, to: range) }
    }

    func addParagraph(paragraph: NSParagraphStyle, to range: NSRange? = nil) {
        self.addAttribute(NSParagraphStyleAttributeName,
                          value: paragraph,
                          range: range ?? self.range)
    }

    func addBaseline(baseline: Float, to range: NSRange? = nil) {
        self.addAttribute(NSBaselineOffsetAttributeName,
                          value: NSNumber(float: baseline),
                          range: range ?? self.range)
    }

    func addKern(kern: Float, to range: NSRange? = nil) {
        self.addAttribute(NSKernAttributeName,
                          value: NSNumber(float: kern),
                          range: range ?? self.range)
    }
#endif
}

public func + (lhs: NSMutableAttributedString, rhs: NSMutableAttributedString) -> NSMutableAttributedString {
#if swift(>=3.0)
    return NSMutableAttributedString(attributedString: lhs)
        .then { $0.append(rhs) }
#else
    return NSMutableAttributedString(attributedString: lhs)
        .then { $0.appendAttributedString(rhs) }
#endif
}
