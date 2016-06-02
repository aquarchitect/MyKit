//
//  CGRect+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

import CoreGraphics

public extension CGRect {

    public var center: CGPoint {
        return CGPointMake(self.midX, self.midY)
    }

    public init(center: CGPoint, sideLength: CGFloat) {
        let radius = sideLength / 2

        self.origin = CGPointMake(center.x - radius, center.y - radius)
        self.size = CGSizeMake(sideLength, sideLength)
    }
}