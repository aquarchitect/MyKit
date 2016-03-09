//
//  UIEdgeInsets+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

public extension UIEdgeInsets {

    var vertical: CGFloat { return self.top + self.bottom }
    var horizontal: CGFloat { return self.left + self.right }

    init(sideLength: CGFloat) {
        self.init(top: sideLength, left: sideLength, bottom: sideLength, right: sideLength)
    }
}