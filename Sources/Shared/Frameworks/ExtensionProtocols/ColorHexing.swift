// 
// ColorHexing.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import CoreGraphics

public protocol ColorHexing: class {

    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
#if os(iOS)
    @discardableResult
    func getRed(_ red: UnsafeMutablePointer<CGFloat>?, green: UnsafeMutablePointer<CGFloat>?, blue: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool

    @discardableResult
    func getHue(_ hue: UnsafeMutablePointer<CGFloat>?, saturation: UnsafeMutablePointer<CGFloat>?, brightness: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool
#elseif os(macOS)
    func getRed(_ red: UnsafeMutablePointer<CGFloat>?, green: UnsafeMutablePointer<CGFloat>?, blue: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?)
    func getHue(_ hue: UnsafeMutablePointer<CGFloat>?, saturation: UnsafeMutablePointer<CGFloat>?, brightness: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?)
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
        guard let hex = value.hexUInt else { return nil }
        self.init(hexUInt: hex, alpha: 1)
    }
}

#if os(iOS)
import UIKit
extension UIColor: ColorHexing {}
#elseif os(macOS)
import AppKit
extension NSColor: ColorHexing {}
#endif
