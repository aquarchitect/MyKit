/*
 * UIBezierPath+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

public extension UIBezierPath {

    convenience init(points: [CGPoint]) {
        self.init()
        drawLines(points)
    }

    convenience init(points: CGPoint...) {
        self.init(points: points)
    }

#if swift(>=3.0)
    func drawLines(_ points: [CGPoint]) {
        precondition(points.count > 1, "Invalid number of points!")

        self.move(to: points.first!)
        points.dropFirst().forEach(self.addLine)
    }

    func drawLines(_ points: CGPoint...) {
        drawLines(points)
    }
#else
    func drawLines(points: [CGPoint]) {
        precondition(points.count > 1, "Invalid number of points!")

        self.moveToPoint(points.first!)
        points.dropFirst().forEach(self.addLineToPoint)
    }

    func drawLines(points: CGPoint...) {
        drawLines(points)
    }
#endif
}

public extension UIBezierPath {

#if swift(>=3.0)
    final func outlineStroke() -> UIBezierPath {
        return CGPath(__byStroking: self.cgPath,
                      transform: nil,
                      lineWidth: self.lineWidth,
                      lineCap: self.lineCapStyle,
                      lineJoin: self.lineJoinStyle,
                      miterLimit: self.miterLimit)
            .flatMap(UIBezierPath.init(cgPath:))
            ?? UIBezierPath()
    }
#else
    final func outlineStroke() -> UIBezierPath {
        return CGPathCreateCopyByStrokingPath(self.CGPath,
                                       nil,
                                       self.lineWidth,
                                       self.lineCapStyle,
                                       self.lineJoinStyle,
                                       self.miterLimit)
            .map(UIBezierPath.init(CGPath:))
            ?? UIBezierPath()
    }

#endif
}
