//
//  UILabel+.swift
//  MyKit
//
//  Created by Hai Nguyen on 10/9/15.
//
//

public extension UILabel {

    public static var sharedInstance: UILabel {
        struct Cache { static let label = UILabel() }
        return Cache.label
    }

    public func heightForText(font: UIFont)(text: String)(width: CGFloat) -> CGFloat {
        self.font = font
        self.text = text
        self.frame.size.width = width
        self.sizeToFit()

        return self.bounds.height
    }
}
