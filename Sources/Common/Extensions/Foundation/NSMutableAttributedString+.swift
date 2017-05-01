// 
// NSMutableAttributedString+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

extension NSMutableAttributedString {

    var range: NSRange {
        return NSMakeRange(0, self.length)
    }

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
}

#if os(iOS)
public extension NSMutableAttributedString {

    func addFont(_ font: UIFont?, to range: NSRange? = nil) {
        font.flatMap { self._addFont($0, to: range) }
    }

    func addColor(_ color: UIColor?, to range: NSRange? = nil) {
        color.flatMap { self._addColor($0, to: range) }
    }
}
#elseif os(OSX)
public extension NSMutableAttributedString {

    func addFont(_ font: NSFont?, to range: NSRange? = nil) {
        font.flatMap { self._addFont($0, to: range) }
    }

    func addColor(_ color: NSColor?, to range: NSRange? = nil) {
        color.flatMap { self._addColor($0, to: range) }
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
}
