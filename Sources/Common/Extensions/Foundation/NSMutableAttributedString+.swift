//
// NSMutableAttributedString+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

#if os(iOS)
import UIKit
public typealias Color = UIColor
public typealias Font = UIFont
#elseif os(OSX)
import AppKit
public typealias Color = NSColor
public typealias Font = NSFont
#endif

extension NSMutableAttributedString {

    var range: NSRange {
        return NSMakeRange(0, self.length)
    }
}

public extension NSMutableAttributedString {

    func addFont(_ font: Font, to range: NSRange? = nil) {
        self.addAttribute(
            NSFontAttributeName,
            value: font,
            range: range ?? self.range
        )
    }

    func addForegroundColor(_ color: Color, to range: NSRange? = nil) {
        self.addAttribute(
            NSForegroundColorAttributeName,
            value: color,
            range: range ?? self.range
        )
    }

    func addStrokeColor(_ color: Color, to range: NSRange? = nil) {
        self.addAttribute(
            NSStrokeColorAttributeName,
            value: color,
            range: range ?? self.range
        )
    }

    func addStrokeWidth(_ width: Float, to range: NSRange? = nil) {
        self.addAttribute(
            NSStrokeWidthAttributeName,
            value: NSNumber(value: width),
            range: range ?? self.range
        )
    }

    func addAlignment(_ alignment: NSTextAlignment, to range: NSRange? = nil) {
        NSMutableParagraphStyle()
            .then({ $0.alignment = alignment })
            .then({ self.addParagraph($0, to: range) })
    }

    func addParagraph(_ paragraph: NSParagraphStyle, to range: NSRange? = nil) {
        self.addAttribute(
            NSParagraphStyleAttributeName,
            value: paragraph,
            range: range ?? self.range
        )
    }

    func addBaseline(_ baseline: Float, to range: NSRange? = nil) {
        self.addAttribute(
            NSBaselineOffsetAttributeName,
            value: NSNumber(value: baseline),
            range: range ?? self.range
        )
    }

    func addKern(_ kern: Float, to range: NSRange? = nil) {
        self.addAttribute(
            NSKernAttributeName,
            value: NSNumber(value: kern),
            range: range ?? self.range
        )
    }
}
