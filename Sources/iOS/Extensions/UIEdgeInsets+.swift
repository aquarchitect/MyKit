/*
 * UIEdgeInsets+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

public extension UIEdgeInsets {

    public var vertical: CGFloat { return self.top + self.bottom }
    public var horizontal: CGFloat { return self.left + self.right }

    public init(sideLength: CGFloat) {
        self.init(top: sideLength, left: sideLength, bottom: sideLength, right: sideLength)
    }
}
