//
// NSFont+.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

import AppKit

public extension NSFont {

    class func boldItalicSystemFont(ofSize size: CGFloat, weight: CGFloat) -> NSFont? {
#if swift(>=4.0)
        let fontManager = NSFontManager.shared
#else
        let fontManager = NSFontManager.shared()
#endif
        return fontManager.font(
            withFamily: NSFont.systemFont(ofSize: size).familyName ?? "",
            traits: [.boldFontMask, .italicFontMask],
            weight: Int(weight),
            size: size
        )
    }

    @available(OSX 10.11, *)
    class func boldItalicSystemFont(ofSize size: CGFloat) -> NSFont? {
#if swift(>=4.0)
        return boldItalicSystemFont(ofSize: size, weight: NSFont.Weight.regular.rawValue)
#else
        return boldItalicSystemFont(ofSize: size, weight: NSFontWeightRegular)
#endif
    }
}

public extension NSFont {

    class func italicSystemFont(ofSize size: CGFloat, weight: CGFloat) -> NSFont? {
#if swift(>=4.0)
        let fontManager = NSFontManager.shared
#else
        let fontManager = NSFontManager.shared()
#endif
        return fontManager.font(
            withFamily: NSFont.systemFont(ofSize: size).familyName ?? "",
            traits: .italicFontMask,
            weight: Int(weight),
            size: size
        )
    }

    @available(OSX 10.11, *)
    class func italicSystemFont(ofSize size: CGFloat) -> NSFont? {
#if swift(>=4.0)
        return italicSystemFont(ofSize: size, weight: NSFont.Weight.regular.rawValue)
#else
        return italicSystemFont(ofSize: size, weight: NSFontWeightRegular)
#endif
    }
}

public extension NSFont {

#if swift(>=4.0)
    class func systemFont(for controlSize: NSControl.ControlSize) -> NSFont {
        return (NSFont.systemFontSize(for:) >>> NSFont.systemFont(ofSize:))(controlSize)
    }
    
    class func boldSystemFont(for controlSize: NSControl.ControlSize) -> NSFont {
        return (NSFont.systemFontSize(for:) >>> NSFont.boldSystemFont(ofSize:))(controlSize)
    }
    
    @available(OSX 10.11, *)
    class func boldItalicSystemFont(for controlSize: NSControl.ControlSize) -> NSFont? {
        return (NSFont.systemFontSize(for:) >>> NSFont.boldItalicSystemFont(ofSize:))(controlSize)
    }
    
    @available(OSX 10.11, *)
    class func italicSystemFont(for controlSize: NSControl.ControlSize) -> NSFont? {
        return (NSFont.systemFontSize(for:) >>> NSFont.italicSystemFont(ofSize:))(controlSize)
    }
#else
    class func systemFont(for controlSize: NSControlSize) -> NSFont {
        return (NSFont.systemFontSize(for:) >>> NSFont.systemFont(ofSize:))(controlSize)
    }

    class func boldSystemFont(for controlSize: NSControlSize) -> NSFont {
        return (NSFont.systemFontSize(for:) >>> NSFont.boldSystemFont(ofSize:))(controlSize)
    }

    @available(OSX 10.11, *)
    class func boldItalicSystemFont(for controlSize: NSControlSize) -> NSFont? {
        return (NSFont.systemFontSize(for:) >>> NSFont.boldItalicSystemFont(ofSize:))(controlSize)
    }

    @available(OSX 10.11, *)
    class func italicSystemFont(for controlSize: NSControlSize) -> NSFont? {
        return (NSFont.systemFontSize(for:) >>> NSFont.italicSystemFont(ofSize:))(controlSize)
    }
#endif
}
