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
#if swift(>=3.0)
        NSLayoutConstraint.activate(self)
#else
        NSLayoutConstraint.activateConstraints(self)
#endif
    }

    func deactivate() {
#if swift(>=3.0)
        NSLayoutConstraint.deactivate(self)
#else
        NSLayoutConstraint.deactivateConstraints(self)
#endif
    }
}
