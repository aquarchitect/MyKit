/*
 * ActionTrailing.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
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
