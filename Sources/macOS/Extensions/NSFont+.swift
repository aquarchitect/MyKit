//
// NSFont+.swift
// MyKit
//
// Created by Hai Nguyen on 4/30/17.
// Copyright (c) 2017 Hai Nguyen.
//

import AppKit

public extension NSFont {

    static func boldItalicSystemFont(ofSize size: CGFloat, weight: CGFloat) -> NSFont? {
        return NSFontManager.shared().font(
            withFamily: NSFont.systemFont(ofSize: size).familyName ?? "",
            traits: [.boldFontMask, .italicFontMask],
            weight: Int(weight),
            size: size
        )
    }

    @available(OSX 10.11, *)
    static func boldItalicSystemFont(ofSize size: CGFloat) -> NSFont? {
        return boldItalicSystemFont(ofSize: size, weight: NSFontWeightRegular)
    }
}

public extension NSFont {

    static func italicSystemFont(ofSize size: CGFloat, weight: CGFloat) -> NSFont? {
        return NSFontManager.shared().font(
            withFamily: NSFont.systemFont(ofSize: size).familyName ?? "",
            traits: .italicFontMask,
            weight: Int(weight),
            size: size
        )
    }

    @available(OSX 10.11, *)
    static func italicSystemFont(ofSize size: CGFloat) -> NSFont? {
        return italicSystemFont(ofSize: size, weight: NSFontWeightRegular)
    }
}

public extension NSFont {

    static func systemFont(for controlSize: NSControlSize) -> NSFont {
        return (NSFont.systemFontSize(for:) >>> NSFont.systemFont(ofSize:))(controlSize)
    }

    static func boldSystemFont(for controlSize: NSControlSize) -> NSFont {
        return (NSFont.systemFontSize(for:) >>> NSFont.boldSystemFont(ofSize:))(controlSize)
    }

    @available(OSX 10.11, *)
    static func boldItalicSystemFont(for controlSize: NSControlSize) -> NSFont? {
        return (NSFont.systemFontSize(for:) >>> NSFont.boldItalicSystemFont(ofSize:))(controlSize)
    }

    @available(OSX 10.11, *)
    static func italicSystemFont(for controlSize: NSControlSize) -> NSFont? {
        return (NSFont.systemFontSize(for:) >>> NSFont.italicSystemFont(ofSize:))(controlSize)
    }
}
