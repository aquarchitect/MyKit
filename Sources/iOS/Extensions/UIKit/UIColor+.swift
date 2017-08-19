//
// UIColor+.swift
// MyKit
//
// Created by Hai Nguyen on 8/18/17.
// Copyright (c) 2017 Hai Nguyen.
//

import UIKit

public extension UIColor {

    func blended(withFraction fraction: CGFloat, of color: UIColor) -> UIColor {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0

        self.getRed (&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return UIColor(
            red: r1*(1-fraction) + r2*fraction,
            green: g1*(1-fraction) + g2*fraction,
            blue: b1*(1-fraction) + b2*fraction,
            alpha: a1*(1-fraction) + a2*fraction
        )
    }
}
