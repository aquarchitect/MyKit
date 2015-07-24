//
//  CGRect+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension CGRect {

    var center: CGPoint { return CGPointMake(self.midX, self.midY) }

    init(center: CGPoint, sideLength: CGFloat) {
        let radius = sideLength / 2

        self.origin = CGPointMake(center.x - radius, center.y - radius)
        self.size = CGSizeMake(sideLength, sideLength)
    }
}