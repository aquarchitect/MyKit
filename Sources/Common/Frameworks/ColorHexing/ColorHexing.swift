//
//  ColorHexinging.swift
//  MyKit
//
//  Created by Hai Nguyen on 5/17/16.
//  
//

import CoreGraphics

public protocol ColorHexing: class {

    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
#if os(iOS)
    func getRed(red: UnsafeMutablePointer<CGFloat>, green: UnsafeMutablePointer<CGFloat>, blue: UnsafeMutablePointer<CGFloat>, alpha: UnsafeMutablePointer<CGFloat>) -> Bool
#elseif os(OSX)
    func getRed(red: UnsafeMutablePointer<CGFloat>, green: UnsafeMutablePointer<CGFloat>, blue: UnsafeMutablePointer<CGFloat>, alpha: UnsafeMutablePointer<CGFloat>)
#endif
}

public extension ColorHexing {

    var hexValue: UInt {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UInt(r * 255) << 16 | UInt(g * 255) << 8 | UInt(b * 255) << 0
    }

    init(hexValue value: UInt, alpha: CGFloat = 1) {
        let r = CGFloat((value & 0xFF0000) >> 16) / 255
        let g = CGFloat((value & 0x00FF00) >> 8) / 255
        let b = CGFloat((value & 0x0000FF) >> 0) / 255

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

public extension ColorHexing {

    var hexCode: String {
        return String(format: "#%06X", hexValue)
    }

    init?(hexCode value: String) {
        guard value.isValidAs(.Hexadecimal) else { return nil }
        let scanner = NSScanner(string: value)
            .then { $0.scanLocation = 1 }

        guard let hex = scanner.scanHexUInt32() else { return nil }
        self.init(hexValue: UInt(hex), alpha: 1)
    }
}

#if os(iOS)
import UIKit
extension UIColor: ColorHexing {}
#elseif os(OSX)
import AppKit
extension NSColor: ColorHexing {}
#endif