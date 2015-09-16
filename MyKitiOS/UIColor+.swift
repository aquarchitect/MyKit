//
//  UIColor+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension UIColor {

    final class func arbitrary() -> UIColor {
        let rand: Void -> CGFloat = { _ in return CGFloat(drand48()) }
        return UIColor(red: rand(), green: rand(), blue: rand(), alpha: 1)
    }
}