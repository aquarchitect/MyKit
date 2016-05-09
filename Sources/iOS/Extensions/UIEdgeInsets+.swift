//
//  UIEdgeInsets+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

public extension UIEdgeInsets {

    public static var zero: UIEdgeInsets { return UIEdgeInsetsZero }

    public var vertical: CGFloat { return self.top + self.bottom }
    public var horizontal: CGFloat { return self.left + self.right }

    public init(sideLength: CGFloat) {
        self.init(top: sideLength, left: sideLength, bottom: sideLength, right: sideLength)
    }
}