//
//  UIColor+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

public extension UIColor {

    public var hexValue: UInt {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UInt(r * 255) << 16 | UInt(g * 255) << 8 | UInt(b * 255) << 0
    }

    public var hexString: String {
        return String(format: "#%06X", hexValue)
    }

    public convenience init(hex: UInt, alpha: CGFloat = 1) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255
        let b = CGFloat((hex & 0x0000FF) >> 0) / 255

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    public convenience init?(hexString string: String) {
        guard string.hasPrefix("#") else { return nil }
        let scanner = NSScanner(string: string)
            .then { $0.scanLocation = 1 }

        guard let hex = scanner.scanHexUInt32() else { return nil }
        self.init(hex: UInt(hex), alpha: 1)
    }

    final public class func random() -> UIColor {
        let rand: Void -> CGFloat = { _ in return CGFloat(drand48()) }
        return UIColor(red: rand(), green: rand(), blue: rand(), alpha: 1)
    }
}