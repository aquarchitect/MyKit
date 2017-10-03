// 
// NSImage+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import AppKit

public extension NSImage {

    func image(withTintColor color: NSColor) -> NSImage {
        guard self.isTemplate else { return self }
        
        return (self.copy() as? NSImage)?.then {
            $0.lockFocus()

            color.set()
#if swift(>=4.0)
            NSRect(origin: .zero, size: $0.size).fill(using: .sourceAtop)
#else
            NSRectFillUsingOperation(.init(origin: .zero, size: $0.size), .sourceAtop)
#endif
            $0.unlockFocus()

            $0.isTemplate = false
        } ?? self
    }
}

public extension NSImage {

    class func render(_ attributedString: NSAttributedString, scale: CGFloat = 1.0) -> NSImage {
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let size = attributedString.size().applying(transform)
        let rect = CGRect(origin: .zero, size: size)

        return NSImage(size: size).then {
            $0.lockFocus()
            attributedString.draw(in: rect)
            $0.unlockFocus()
        }
    }
}
