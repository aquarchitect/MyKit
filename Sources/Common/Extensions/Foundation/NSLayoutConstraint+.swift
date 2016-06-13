/*
 * NSLayoutConstraint+.swift
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
#elseif os(OSX)
import AppKit
#endif

public extension NSLayoutConstraint {

#if os(iOS)
    public convenience init(view view1: UIView, attribute attr1: NSLayoutAttribute, relatedBy relation: NSLayoutRelation, toView view2: UIView?, attribute attr2: NSLayoutAttribute, multiplier: CGFloat, constant c: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) {
        self.init(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: c)
        self.priority = priority
    }

    public static func constraint(format format: String, views: [String: UIView], metrics: [String: CGFloat]? = nil) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat(format, options: [], metrics: metrics, views: views)
    }
#elseif os(OSX)
    public convenience init(view view1: NSView, attribute attr1: NSLayoutAttribute, relatedBy relation: NSLayoutRelation, toView view2: NSView?, attribute attr2: NSLayoutAttribute, multiplier: CGFloat, constant c: CGFloat, priority: NSLayoutPriority = NSLayoutPriorityRequired) {
    self.init(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: c)
    self.priority = priority
    }

    public static func constraint(format format: String, views: [String: NSView], metrics: [String: CGFloat]? = nil) -> [NSLayoutConstraint] {
    return NSLayoutConstraint.constraintsWithVisualFormat(format, options: [], metrics: metrics, views: views)
    }
#endif
}

/// :nodoc:
public extension Array where Element: NSLayoutConstraint {

    public func activate() {
        NSLayoutConstraint.activateConstraints(self)
    }

    public func deactivate() {
        NSLayoutConstraint.deactivateConstraints(self)
    }
}