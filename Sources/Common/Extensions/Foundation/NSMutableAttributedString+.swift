//
//  NSMutableAttributedString+.swift
//  MyKit
//
//  Created by Hai Nguyen on 10/15/15.
//
//

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