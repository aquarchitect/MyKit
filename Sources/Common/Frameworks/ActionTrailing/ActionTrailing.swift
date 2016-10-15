/*
 * ActionTrailing.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

private var GlobalToken: UInt8 = 0

import Foundation.NSObject

public protocol ActionTrailing: class {}

extension ActionTrailing {

    func setAction(_ handle: @escaping (Self) -> Void) {
        objc_setAssociatedObject(self,
                                 &GlobalToken,
                                 ActionWrapper(handle),
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }

    func executeAction() {
        (objc_getAssociatedObject(self, &GlobalToken) as? ActionWrapper<Self>)?.handle(self)
    }
}

extension NSObject {

    func handleAction() {
        (self as? ActionTrailing)?.executeAction()
    }
}

#if os(iOS)
import UIKit

extension UIControl: ActionTrailing {}

public extension ActionTrailing where Self: UIControl {

    func addAction(_ handle: @escaping (Self) -> Void, for controlEvents: UIControlEvents) {
        self.setAction(handle)
        self.addTarget(self, action: #selector(handleAction), for: controlEvents)
    }
}

extension UIGestureRecognizer: ActionTrailing {}

public extension ActionTrailing where Self: UIGestureRecognizer {

    func addAction(_ handle: @escaping (Self) -> Void) {
        self.setAction(handle)
        self.addTarget(self, action: #selector(handleAction))
    }
}
#elseif os(macOS)
import AppKit

extension NSControl: ActionTrailing {}

public extension ActionTrailing where Self: NSControl {

    func addAction(_ handle: @escaping (Self) -> Void) {
        self.setAction(handle)
        self.action = #selector(actionExecuted)
        self.target = self
    }
}

extension NSGestureRecognizer: ActionTrailing {}

public extension ActionTrailing where Self: NSGestureRecognizer {

    func addAction(_ handle: @escaping (Self) -> Void) {
        self.setAction(handle)
        self.action = #selector(actionExecuted)
        self.target = self
    }
}
#endif
