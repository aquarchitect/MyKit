//
//  NSMutableAttributedString+.swift
//  MyKit
//
//  Created by Hai Nguyen on 10/15/15.
//
//

public extension NSMutableAttributedString {

    private var range: NSRange { return NSMakeRange(0, self.length) }

    #if os(iOS)

    public func addFontAttribute(value: UIFont, range: NSRange?) { self.addFontAttribute(value, range) }

    public func addColorAttribute(value: UIColor, range: NSRange?) { self.addColorAttribute(value, range) }

    #elseif os(OSX)

    public func addFontAttribute(value: NSFont, range: NSRange?) { self.addFontAttribute(value, range: range) }

    public func addColorAttribute(value: NSColor, range: NSRange?) { self.addColorAttribute(value, range: range) }

    #endif

    private func addFontAttribute(value: AnyObject, _ range: NSRange?) {
        self.addAttribute(NSFontAttributeName, value: value, range: range ?? self.range)
    }

    private func addColorAttribute(value: AnyObject, _ range: NSRange?) {
        self.addAttribute(NSForegroundColorAttributeName, value: value, range: range ?? self.range)
    }

    public func addAlignmentAttribute(value: NSTextAlignment, range: NSRange?) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = value

        self.addParagraphAttribute(paragraph, range: range)
    }

    public func addParagraphAttribute(value: NSParagraphStyle, range: NSRange?) {
        self.addAttribute(NSParagraphStyleAttributeName, value: value, range: range ?? self.range)
    }

    public func addBaselineAttribute(value: Float, range: NSRange?) {
        self.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(float: value), range: range ?? self.range)
    }
}