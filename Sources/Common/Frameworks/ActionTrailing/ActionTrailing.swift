// 
// ActionTrailing.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import Foundation

private var GlobalToken: UInt8 = 0

public protocol ActionTrailing: class {}

extension ActionTrailing where Self: NSObject {

    var block: ((Self) -> Void)? {
        get { return getAssociatedObject() }
        set { newValue.map(setAssociatedObject) }
    }
}

#if os(iOS)
import UIKit

extension UIControl: ActionTrailing {

    func handleAction(_ sender: UIControl) {
        block?(sender)
    }
}

public extension ActionTrailing where Self: UIControl {

    func addAction(_ block: @escaping (Self) -> Void, for controlEvents: UIControlEvents) {
        self.block = block
        self.addTarget(self, action: #selector(handleAction), for: controlEvents)
    }
}

extension UIGestureRecognizer: ActionTrailing {

    func handleAction(_ sender: UIGestureRecognizer) {
        block?(sender)
    }
}

public extension ActionTrailing where Self: UIGestureRecognizer {

    func addAction(_ block: @escaping (Self) -> Void) {
        self.block = block
        self.addTarget(self, action: #selector(handleAction))
    }
}

extension UIBarButtonItem: ActionTrailing {

    func handleAction(_ sender: UIBarButtonItem) {
        block?(sender)
    }
}

public extension ActionTrailing where Self: UIBarButtonItem {

    func addAction(_ block: @escaping (Self) -> Void) {
        self.block = block
        self.target = self
        self.action = #selector(handleAction)
    }
}

#elseif os(OSX)
import AppKit

extension NSControl: ActionTrailing {

    func handleAction(_ sender: NSControl) {
        block?(sender)
    }
}

public extension ActionTrailing where Self: NSControl {

    func addAction(_ block: @escaping (Self) -> Void) {
        self.block = block
        self.action = #selector(handleAction)
        self.target = self
    }
}

extension NSMenuItem: ActionTrailing {

    func handleAction(_ sender: NSMenuItem) {
        block?(sender)
    }
}

public extension ActionTrailing where Self: NSMenuItem {

    func addAction(_ block: @escaping (Self) -> Void) {
        self.block = block
        self.action = #selector(handleAction)
        self.target = self
    }
}

extension NSGestureRecognizer: ActionTrailing {

    func handleAction(_ sender: NSGestureRecognizer) {
        block?(sender)
    }
}

public extension ActionTrailing where Self: NSGestureRecognizer {

    func addAction(_ block: @escaping (Self) -> Void) {
        self.block = block
        self.action = #selector(handleAction)
        self.target = self
    }
}
#endif
