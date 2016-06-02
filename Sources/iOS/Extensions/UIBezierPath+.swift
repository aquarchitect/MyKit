//
//  UIBezierPath+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

import UIKit

public extension UIBezierPath {

    public convenience init(points: [CGPoint]) {
        self.init()

        for (index, point) in points.enumerate() {
            if index == 0 { self.moveToPoint(point); continue }
            self.addLineToPoint(point)
        }
    }

    public convenience init(points: CGPoint...) {
        self.init(points: points)
    }

    final func outlineStroke() -> UIBezierPath {
        return UIBezierPath(CGPath: CGPathCreateCopyByStrokingPath(self.CGPath, nil, self.lineWidth, self.lineCapStyle, self.lineJoinStyle, self.miterLimit)!)
    }
}