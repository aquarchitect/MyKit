//
//  HexColoringing.swift
//  MyKit
//
//  Created by Hai Nguyen on 5/17/16.
//  
//

public protocol HexColoring: class {

    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    func getRed(red: UnsafeMutablePointer<CGFloat>, green: UnsafeMutablePointer<CGFloat>, blue: UnsafeMutablePointer<CGFloat>, alpha: UnsafeMutablePointer<CGFloat>) -> Bool
}

public extension HexColoring {

    public var hexUInt: UInt {
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

public extension HexColoring {

    var hexString: String {
        return String(format: "#%06X", hexUInt)
    }

    init?(hexString value: String) {
        guard value.isValidAs(.Hexadecimal) else { return nil }
        let scanner = NSScanner(string: value)
            .then { $0.scanLocation = 1 }

        guard let hex = scanner.scanHexUInt32() else { return nil }
        self.init(hexUInt: UInt(hex), alpha: 1)
    }
}

#if os(iOS)
extension UIColor: HexColoring {}
#elseif os(OSX)
extension NSColor: HexColoring {}
#endif