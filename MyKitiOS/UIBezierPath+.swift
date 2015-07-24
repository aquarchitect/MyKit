//
//  UIBezierPath+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

let ln: CGFloat = 44
private let wt: CGFloat = 4

private func * (percent: (x: CGFloat, y: CGFloat), length: CGFloat) -> CGPoint {
    return CGPointMake(percent.x * length, percent.y * length)
}

public extension UIBezierPath {

    private typealias curve = (p: CGPoint, c1: CGPoint, c2: CGPoint?)

    private static var translation: CGAffineTransform { return CGAffineTransformMakeTranslation(ln / 2, ln / 2) }

    static var Circle: UIBezierPath {
        let rect = CGRect(center: CGPointZero, sideLength: ln)
        let path = UIBezierPath(ovalInRect: rect)
        path.lineWidth = wt
        path.applyTransform(translation)
        return path
    }

    public static var Exmark: UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint((-0.2, -0.2) * ln)
        path.addLineToPoint((0.2, 0.2) * ln)
        path.moveToPoint((0.2, -0.2) * ln)
        path.addLineToPoint((-0.2, 0.2) * ln)
        path.lineWidth = wt
        path.applyTransform(translation)
        return path
    }

    public static var Checkmark: UIBezierPath {
        let transform = CGAffineTransformMakeTranslation(0.45 * ln, 0.7 * ln)
        let path = UIBezierPath()
        path.moveToPoint((-0.2, -0.2) * ln)
        path.addLineToPoint(CGPointZero)
        path.addLineToPoint((0.37, -0.37) * ln)
        path.lineWidth = wt
        path.applyTransform(transform)
        return path
    }

    public static var Arrow: Direction -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint((-0.25, -0.25) * ln)
        path.addLineToPoint(CGPointZero)
        path.addLineToPoint((-0.25, 0.25) * ln)
        path.lineWidth = wt
        path.applyTransform(CGAffineTransformMakeTranslation(0.15 * ln, 0))
        let rotate: Direction -> CGAffineTransform = {
            let rotation: CGAffineTransform
            switch $0 {
            case .Top: rotation = CGAffineTransformMakeRotation(-PI / 2)
            case .Left: rotation = CGAffineTransformMakeRotation(PI)
            case .Bottom: rotation = CGAffineTransformMakeRotation(PI / 2)
            case .Right: rotation = CGAffineTransformMakeRotation(0)
            }
            return CGAffineTransformConcat(rotation, translation)
        }
        return { path.applyTransform(rotate($0)); return path }
    }

    public static var Clock: UIBezierPath {
        let path = UIBezierPath(arcCenter: CGPointZero, radius: 0.39 * ln, startAngle: 0, endAngle: 2*PI, clockwise: true)
        path.moveToPoint((-0.15, 0.25) * ln)
        path.addLineToPoint(CGPointZero)
        path.addLineToPoint((0, -0.33) * ln)
        path.lineWidth = wt / 1.5
        path.applyTransform(translation)
        return path
    }

    public static var Bell: UIBezierPath {
        let lipLeft: curve = ((-0.35, 0.25) * ln, (-0.27, 0.25) * ln, nil)
        let lipRight: curve = ((0.35, 0.25) * ln, (0.27, 0.25) * ln, nil)

        let waistLeft: curve = ((-0.19, -0.08) * ln, (-0.19, 0.12) * ln, (-0.19, -0.44) * ln)
        let waistRight: curve = ((0.19, -0.08) * ln, (0.19, 0.12) * ln, (0.19, -0.44) * ln)

        let path = UIBezierPath()
        path.moveToPoint((-0.1, 0.25) * ln)
        path.addLineToPoint(lipLeft.p)
        path.addCurveToPoint(waistLeft.p, controlPoint1: lipLeft.c1, controlPoint2: waistLeft.c1)
        path.addCurveToPoint(waistRight.p, controlPoint1: waistLeft.c2!, controlPoint2: waistRight.c2!)
        path.addCurveToPoint(lipRight.p, controlPoint1: waistRight.c1, controlPoint2: lipRight.c1)
        path.addLineToPoint((0.1, 0.25) * ln)
        path.moveToPoint((0, 0.15) * ln)
        path.addLineToPoint((0, 0.35) * ln)
        path.lineWidth = wt / 1.5
        path.applyTransform(translation)

        return path
    }

    public static var Pin: UIBezierPath {
        let center = (0, -0.08) * ln
        let rect = CGRect(center: center, sideLength: 0.23 * ln)
        let path = UIBezierPath(ovalInRect: rect)
        path.moveToPoint((0, 0.35) * ln)
        path.addArcWithCenter(center, radius: 0.28 * ln, startAngle: 0.77 * PI, endAngle: 0.23 * PI, clockwise: true)
        path.closePath()
        path.lineWidth = wt / 1.5
        path.applyTransform(translation)
        return path
    }

    public static var Human: UIBezierPath {
        let shoulderLeft: curve = ((-0.35, 0.33) * ln, (-0.35, 0.1) * ln, nil)
        let shoulderRight: curve = ((0.35, 0.33) * ln, (0.35, 0.1) * ln, nil)

        let neckLeft: curve = ((-0.07, 0.08) * ln, (-0.07, 0.25) * ln, (-0.07, 0) * ln)
        let neckRight: curve = ((0.07, 0.08) * ln, (0.07, 0.25) * ln, (0.07, 0) * ln)

        let earLeft: curve = ((-0.15, -0.2) * ln, (-0.15, 0.1) * ln, (-0.15, -0.37) * ln)
        let earRight: curve = ((0.15, -0.2) * ln, (0.15, 0.1) * ln, (0.15, -0.37) * ln)

        let path = UIBezierPath()
        path.moveToPoint(shoulderLeft.p)
        path.addCurveToPoint(neckLeft.p, controlPoint1: shoulderLeft.c1, controlPoint2: neckLeft.c1)
        path.addCurveToPoint(earLeft.p, controlPoint1: neckLeft.c2!, controlPoint2: earLeft.c1)
        path.addCurveToPoint(earRight.p, controlPoint1: earLeft.c2!, controlPoint2: earRight.c2!)
        path.addCurveToPoint(neckRight.p, controlPoint1: earRight.c1, controlPoint2: neckRight.c2!)
        path.addCurveToPoint(shoulderRight.p, controlPoint1: neckRight.c1, controlPoint2: shoulderRight.c1)
        path.lineWidth = wt / 1.5
        path.applyTransform(CGAffineTransformMakeTranslation(0.5 * ln, 0.43 * ln))
        return path
    }

    public static var Stack: UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint((-0.3, 0) * ln)
        path.addLineToPoint((0.3, 0) * ln)
        path.moveToPoint((-0.35, -0.22) * ln)
        path.addLineToPoint((0.25, -0.22) * ln)
        path.moveToPoint((-0.25, 0.22) * ln)
        path.addLineToPoint((0.35, 0.22) * ln)
        path.lineWidth = wt / 1.5
        path.applyTransform(translation)
        return path
    }

    public static var Loop: UIBezierPath {
        func arc(angle: CGFloat) -> UIBezierPath {
            let translation = CGAffineTransformMakeTranslation(-0.35 * ln, 0)
            let rotation = CGAffineTransformMakeRotation(-0.2 * PI)
            let transform = CGAffineTransformConcat(rotation, translation)
            let path = UIBezierPath()
            path.moveToPoint((0, -0.14) * ln)
            path.addLineToPoint(CGPointZero)
            path.addLineToPoint((0.14, 0) * ln)
            path.applyTransform(transform)
            path.moveToPoint((-0.35, 0) * ln)
            path.addArcWithCenter(CGPointZero, radius: 0.35 * ln, startAngle: -PI, endAngle: -0.16 * PI, clockwise: true)
            path.applyTransform(CGAffineTransformMakeRotation(angle))
            return path
        }
        let path = arc(0)
        path.appendPath(arc(-PI))
        path.lineWidth = wt / 1.5
        path.applyTransform(translation)
        return path
    }
}

public extension UIBezierPath {

    public convenience init(points: CGPoint...) {
        self.init()

        for (index, point) in points.enumerate() {
            if index == 0 { self.moveToPoint(point); continue }
            self.addLineToPoint(point)
        }
    }

    final func outlineStroke() -> UIBezierPath {
        return UIBezierPath(CGPath: CGPathCreateCopyByStrokingPath(self.CGPath, nil, self.lineWidth, self.lineCapStyle, self.lineJoinStyle, self.miterLimit)!)
    }
}