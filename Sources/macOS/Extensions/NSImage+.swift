/*
 * NSImage+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 11/4/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

import AppKit

public extension NSImage {

    convenience init(attributedString: NSAttributedString) {
        let size = attributedString.size()
        self.init(size: size)
        self.isTemplate = true

        self.lockFocus()
        attributedString.draw(in: .init(origin: .zero, size: size))
        self.unlockFocus()
    }
}
