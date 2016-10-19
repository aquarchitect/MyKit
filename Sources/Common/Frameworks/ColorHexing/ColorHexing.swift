/*
 * ColorHexing.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CoreGraphics

public protocol ColorHexing: class {

    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
#if swift(>=3.0)
#if os(iOS)
    @discardableResult
    func getRed(_ red: UnsafeMutablePointer<CGFloat>?, green: UnsafeMutablePointer<CGFloat>?, blue: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool
#elseif os(OSX)
    @discardableResult
    func getRed(_ red: UnsafeMutablePointer<CGFloat>?, green: UnsafeMutablePointer<CGFloat>?, blue: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?)
#endif
#else
#if os(iOS)
    func getRed(red: UnsafeMutablePointer<CGFloat>, green: UnsafeMutablePointer<CGFloat>, blue: UnsafeMutablePointer<CGFloat>, alpha: UnsafeMutablePointer<CGFloat>) -> Bool
#elseif os(OSX)
    func getRed(red: UnsafeMutablePointer<CGFloat>, green: UnsafeMutablePointer<CGFloat>, blue: UnsafeMutablePointer<CGFloat>, alpha: UnsafeMutablePointer<CGFloat>)
#endif
#endif
}

public extension ColorHexing {

    var hexUInt: UInt {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UInt(r * 255) << 16 | UInt(g * 255) << 8 | UInt(b * 255) << 0
    }

    init(hexUInt value: UInt, alpha: CGFloat = 1) {
        let r = CGFloat((value & 0xFF0000) >> 16) / 255
        let g = CGFloat((value & 0x00FF00) >> 8) / 255
        let b = CGFloat((value & 0x0000FF) >> 0) / 255

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

public extension ColorHexing {

    var hexString: String {
        return String(format: "#%06X", hexUInt)
    }

    init?(hexString value: String) {
#if swift(>=3.0)
        guard let hex = value.hexUInt else { return nil }
#else
        guard let hex = value.toHexUInt() else { return nil }
#endif
        self.init(hexUInt: hex, alpha: 1)
    }
}

#if os(iOS)
import UIKit.UIColor
extension UIColor: ColorHexing {}
#elseif os(OSX)
import AppKit.NSColor
extension NSColor: ColorHexing {}
#endif
