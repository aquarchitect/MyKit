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

    func _addFont(_ font: AnyObject?, to range: NSRange?) {
        self.addAttribute(NSFontAttributeName, value: font, range: range ?? self.range)
    }

    func _addColor(_ color: AnyObject?, to range: NSRange?) {
        self.addAttribute(NSForegroundColorAttributeName, value: color, range: range ?? self.range)
    }
}

#if os(iOS)
public extension NSMutableAttributedString {

    func addFont(_ font: UIFont?, to range: NSRange? = nil) {
        self._addFont(font, to: range)
    }

    func addColor(_ color: UIColor?, to range: NSRange? = nil) {
        self._addColor(color, to: range)
    }
}
#elseif os(macOS)
public extension NSMutableAttributedString {

    func addFont(_ font: NSFont?, to range: NSRange? = nil) {
        self._add(font: font, to: range)
    }

    func addColor(_ color: NSColor?, to range: NSRange? = nil) {
        self._add(color: color, to: range)
    }
}
#endif

public extension NSMutableAttributedString {

    func addAlignment(_ alignment: NSTextAlignment, to range: NSRange? = nil) {
        NSMutableParagraphStyle()
            .then { $0.alignment = alignment }
            .then { self.addParagraph($0, to: range) }
    }

    func addParagraph(_ paragraph: NSParagraphStyle, to range: NSRange? = nil) {
        self.addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: range ?? self.range)
    }

    func addBaseline(_ baseline: Float, to range: NSRange? = nil) {
        self.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(value: baseline), range: range ?? self.range)
    }

    func addKern(_ kern: Float, to range: NSRange? = nil) {
        self.addAttribute(NSKernAttributeName, value: NSNumber(value: kern), range: range ?? self.range)
    }
}

public func + (lhs: NSMutableAttributedString, rhs: NSMutableAttributedString) -> NSMutableAttributedString {
    return NSMutableAttributedString(attributedString: lhs).then { $0.append(rhs) }
}
