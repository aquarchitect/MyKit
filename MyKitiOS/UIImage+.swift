//
//  UIImage+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension UIImage {

    public static func stroke(path: UIBezierPath, _ color: UIColor) -> UIImage {
        let draw = { path.stroke() }
        let render = { drawInState($0, color, draw) }
        return renderInContext(render)
    }

    public static func fill(path: UIBezierPath, _ color: UIColor) -> UIImage {
        let render: Render = { ctx in drawInState(ctx, color) {
            CGContextAddPath(ctx, UIBezierPath.Circle.CGPath)
            CGContextAddPath(ctx, path.outlineStroke().CGPath)
            CGContextFillPath(ctx)
            }}
        return renderInContext(render)
    }

    public static func border(path: UIBezierPath, _ color: UIColor) -> UIImage {
        let draw: Void -> Void = { UIBezierPath.Circle.stroke(); path.stroke() }
        return renderInContext { drawInState($0, color, draw) }
    }

    private static func renderInContext(render: Render) -> UIImage {
        return MyKitiOS.renderInContext(CGSize(sideLength: ln), opaque: false, render: render)
    }

    private static func drawInState(context: CGContextRef, _ color: UIColor, _ draw: Void -> Void) {
        MyKitiOS.drawInState(context) { color.set(); draw() }
    }
}