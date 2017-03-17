/*
 * ActionTrailing.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

private var GlobalToken: UInt8 = 0

import Foundation

public protocol ActionTrailing: class {}

extension ActionTrailing {

    func setAction(_ handler: @escaping (Self) -> Void) {
        objc_setAssociatedObject(
            self,
            &GlobalToken,
            ActionWrapper(handler),
            objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC
        )
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

    func addAction(_ handler: @escaping (Self) -> Void, for controlEvents: UIControlEvents) {
        self.setAction(handler)
        self.addTarget(self, action: #selector(handleAction), for: controlEvents)
    }
}

extension UIGestureRecognizer: ActionTrailing {}

public extension ActionTrailing where Self: UIGestureRecognizer {

    func addAction(_ handler: @escaping (Self) -> Void) {
        self.setAction(handler)
        self.addTarget(self, action: #selector(handleAction))
    }
}

extension UIBarButtonItem: ActionTrailing {}

public extension ActionTrailing where Self: UIBarButtonItem {

    func addAction(_ handler: @escaping (Self) -> Void) {
        self.setAction(handler)
        self.target = self
        self.action = #selector(handleAction)
    }
}

#elseif os(OSX)
import AppKit

extension NSControl: ActionTrailing {}

public extension ActionTrailing where Self: NSControl {

    func addAction(_ handler: @escaping (Self) -> Void) {
        self.setAction(handler)
        self.action = #selector(handleAction)
        self.target = self
    }
}

extension NSMenuItem: ActionTrailing {}

public extension ActionTrailing where Self: NSMenuItem {

    func addAction(_ handler: @escaping (Self) -> Void) {
        self.setAction(handler)
        self.action = #selector(handleAction)
        self.target = self
    }
}

extension NSGestureRecognizer: ActionTrailing {}

public extension ActionTrailing where Self: NSGestureRecognizer {

    func addAction(_ handler: @escaping (Self) -> Void) {
        self.setAction(handler)
        self.action = #selector(handleAction)
        self.target = self
    }
}
#endif
