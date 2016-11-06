/*
 * NSLayoutConstraint+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

/// :nodoc:
public extension Array where Element: NSLayoutConstraint {

    func activate() {
        NSLayoutConstraint.activate(self)
    }

    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
}
