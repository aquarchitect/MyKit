//
//  UILabel+.swift
//  MyKit
//
//  Created by Hai Nguyen on 10/9/15.
//
//

import UIKit

public extension UILabel {

    public static var dummyInstance: UILabel {
        struct Cache { static let label = UILabel() }
        return Cache.label
    }

    public func heightOf(width: CGFloat, font: UIFont, text: String) -> CGFloat {
        self.frame.size.width = width
        self.font = font
        self.text = text
        self.sizeToFit()

        return self.bounds.height
    }
}
