/*
 * NSImage+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import AppKit

public extension NSImage {

    convenience init(attributedString: NSAttributedString) {
        let size = attributedString.size()
        self.init(size: size)

        self.lockFocus()
        let rect = NSRect(origin: .zero, size: size)
        attributedString.draw(in: rect)
        self.unlockFocus()
    }

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
