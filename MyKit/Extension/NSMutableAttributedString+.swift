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
        public func addFontAttribute(value: UIFont?, range: NSRange? = nil) {
            self.addFontAttribute(value, range)
        }

        public func addColorAttribute(value: UIColor?, range: NSRange? = nil) {
            self.addColorAttribute(value, range)
        }
    #elseif os(OSX)
        public func addFontAttribute(value: NSFont?, range: NSRange? = nil) {
            self.addFontAttribute(value, range)
        }

        public func addColorAttribute(value: NSColor?, range: NSRange? = nil) {
            self.addColorAttribute(value, range)
        }
    #endif

    private func addFontAttribute(value: AnyObject?, _ range: NSRange?) {
        guard let _value = value else { return }
        self.addAttribute(NSFontAttributeName, value: _value, range: range ?? self.range)
    }

    private func addColorAttribute(value: AnyObject?, _ range: NSRange?) {
        guard let _value = value else { return }
        self.addAttribute(NSForegroundColorAttributeName, value: _value, range: range ?? self.range)
    }

    public func addAlignmentAttribute(value: NSTextAlignment, _ range: NSRange?) {
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

    public func addKernAttribute(value: Float, range: NSRange?) {
        self.addAttribute(NSKernAttributeName, value: NSNumber(float: value), range: range ?? self.range)
    }
}