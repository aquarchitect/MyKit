//
//  UIEdgeInsets+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension UIEdgeInsets {

    var vertical: CGFloat { return self.top + self.bottom }
    var horizontal: CGFloat { return self.left + self.right }

    init(length: CGFloat) {
        self.init(top: length, left: length, bottom: length, right: length)
    }
}