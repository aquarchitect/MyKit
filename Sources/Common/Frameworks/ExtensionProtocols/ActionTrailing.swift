//
// ActionTrailing.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import Foundation

public protocol ActionTrailing: ObjectAssociating {}

extension ActionTrailing {

    func execute() {
        _ = getAssociatedObject().map {
            (block: (Self) -> Void) in
            block(self)
        }
   }
}

extension NSObject {

    @objc func handleAction() {
        (self as? ActionTrailing)?.execute()
    }
}

#if os(iOS)
import UIKit

extension UIControl: ActionTrailing {}

public extension ActionTrailing where Self: UIControl {

    func addAction(_ block: @escaping (Self) -> Void, for controlEvents: UIControlEvents) {
        self.setAssociatedObject(block)
        self.addTarget(
            self, action:
            #selector(handleAction),
            for: controlEvents
        )
    }
}

extension UIGestureRecognizer: ActionTrailing {}

public extension ActionTrailing where Self: UIGestureRecognizer {

    func addAction(_ block: @escaping (Self) -> Void) {
        self.setAssociatedObject(block)
        self.addTarget(self, action: #selector(handleAction))
    }
}

extension UIBarButtonItem: ActionTrailing {}

public extension ActionTrailing where Self: UIBarButtonItem {

    func addAction(_ block: @escaping (Self) -> Void) {
        self.setAssociatedObject(block)
        self.target = self
        self.action = #selector(handleAction)
    }
}

#elseif os(OSX)
import AppKit

extension NSControl: ActionTrailing {}

public extension ActionTrailing where Self: NSControl {

    func addAction(_ block: @escaping (Self) -> Void) {
        self.setAssociatedObject(block)
        self.action = #selector(handleAction)
        self.target = self
    }
}

extension NSMenuItem: ActionTrailing {}

public extension ActionTrailing where Self: NSMenuItem {

    func addAction(_ block: @escaping (Self) -> Void) {
        self.setAssociatedObject(block)
        self.action = #selector(handleAction)
        self.target = self
    }
}

extension NSGestureRecognizer: ActionTrailing {}

public extension ActionTrailing where Self: NSGestureRecognizer {

    func addAction(_ block: @escaping (Self) -> Void) {
        self.setAssociatedObject(block)
        self.action = #selector(handleAction)
        self.target = self
    }
}
#endif
