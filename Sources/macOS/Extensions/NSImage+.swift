/*
 * NSImage+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import AppKit

public extension NSImage {

    func image(withTintColor color: NSColor) -> NSImage {
        guard self.isTemplate else { return self }

        return (self.copy() as? NSImage)?.then {
            $0.lockFocus()

            color.set()
            NSRectFillUsingOperation(.init(origin: .zero, size: $0.size), .sourceAtop)
            $0.unlockFocus()

            $0.isTemplate = false
        } ?? self
    }
}

public extension NSImage {

    static func render(_ attributedString: NSAttributedString) -> NSImage {
        let size = attributedString.size()

        return NSImage(size: size).then {
            $0.lockFocus()
            attributedString.draw(in: .init(origin: .zero, size: size))
            $0.unlockFocus()
        }
    }
}
