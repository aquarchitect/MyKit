//
//  UIColor+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

public extension UIColor {

    public convenience init(hex: Int, alpha: CGFloat = 1) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255
        let b = CGFloat((hex & 0x0000FF) >> 0) / 255

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    final class func random() -> UIColor {
        let rand: Void -> CGFloat = { _ in return CGFloat(drand48()) }
        return UIColor(red: rand(), green: rand(), blue: rand(), alpha: 1)
    }
}