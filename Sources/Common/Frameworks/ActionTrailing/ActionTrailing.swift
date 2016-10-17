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

#if swift(>=3.0)
    func setAction(_ handle: @escaping (Self) -> Void) {
        objc_setAssociatedObject(self, &GlobalToken, ActionWrapper(handle),
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
#else
    func setAction(handle: (Self) -> Void) {
        objc_setAssociatedObject(self, &GlobalToken, ActionWrapper(handle),
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
#endif

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

#if swift(>=3.0)
    func addAction(_ handle: @escaping (Self) -> Void, for controlEvents: UIControlEvents) {
        self.setAction(handle)
        self.addTarget(self, action: #selector(handleAction), for: controlEvents)
    }
#else
    func addAction(handle: (Self) -> Void, forControlEvents controlEvents: UIControlEvents) {
        self.setAction(handle)
        self.addTarget(self, action: #selector(handleAction), forControlEvents: controlEvents)
    }
#endif
}

extension UIGestureRecognizer: ActionTrailing {}

public extension ActionTrailing where Self: UIGestureRecognizer {

#if swift(>=3.0)
    func addAction(_ handle: @escaping (Self) -> Void) {
        self.setAction(handle)
        self.addTarget(self, action: #selector(handleAction))
    }
#else
    func addAction(handle: (Self) -> Void) {
        self.setAction(handle)
        self.addTarget(self, action: #selector(handleAction))
    }
#endif
}
#elseif os(OSX)
import AppKit

extension NSControl: ActionTrailing {}

public extension ActionTrailing where Self: NSControl {

#if swift(>=3.0)
    func addAction(_ handle: @escaping (Self) -> Void) {
        self.setAction(handle)
        self.action = #selector(handleAction)
        self.target = self
    }
#else
    func addAction(handle: (Self) -> Void) {
        self.setAction(handle)
        self.action = #selector(handleAction)
        self.target = self
    }
#endif
}

extension NSGestureRecognizer: ActionTrailing {}

public extension ActionTrailing where Self: NSGestureRecognizer {

#if swift(>=3.0)
    func addAction(_ handle: @escaping (Self) -> Void) {
        self.setAction(handle)
        self.action = #selector(handleAction)
        self.target = self
    }
#else
    func addAction(handle: (Self) -> Void) {
        self.setAction(handle)
        self.action = #selector(handleAction)
        self.target = self
    }
#endif
}
#endif
