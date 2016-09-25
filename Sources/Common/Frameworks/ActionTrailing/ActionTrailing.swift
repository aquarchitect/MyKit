/*
 * ActionTrailing.swift
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

import Foundation.NSObject

private var token = String(#file)
public protocol ActionTrailing: class {}


private extension ActionTrailing {

    func setAction(_ block: @escaping (Self) -> Void) {
        let obj: AnyObject = unsafeBitCast(ActionWrapper(block), to: AnyObject.self)
        objc_setAssociatedObject(self, &token, obj, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
}

extension NSObject {

    func handleBlock() {
        unsafeBitCast(objc_getAssociatedObject(self, &token), to: ActionWrapper.self).block(self)
    }
}

#if os(iOS)
import UIKit.UIControl

extension UIControl: ActionTrailing {}

public extension ActionTrailing where Self: UIControl {

    func addAction(block: @escaping (Self) -> Void, for controlEvents: UIControlEvents) {
        self.setAction(block)
        self.addTarget(self, action: #selector(handleBlock), for: controlEvents)
    }
}

import UIKit.UIGestureRecognizer

extension UIGestureRecognizer: ActionTrailing {}

public extension ActionTrailing where Self: UIGestureRecognizer {

    func addAction(block: @escaping (Self) -> Void) {
        self.setAction(block)
        self.addTarget(self, action: #selector(handleBlock))
    }
}
#elseif os(macOS)
import AppKit.NSControl

extension NSControl: ActionTrailing {}

public extension ActionTrailing where Self: NSControl {

    func addAction(block: @escaping (Self) -> Void, for property: String) {
        self.setAction(block)
        self.setValue("handleBlock", forKey: property)
        self.target = self
    }
}
#endif
