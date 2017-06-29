// 
// NSBezierPath+.swift
// MyKit
// 
// Created by Hai Nguyen
// Copyright (c) 2016 Hai Nguyen.
// 

import AppKit

public extension NSBezierPath {

    var cgPath: CGPath {
        let path = CGMutablePath()
        let points = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)

        for i in 0 ..< self.elementCount {
            switch self.element(at: i, associatedPoints: points) {
            case .moveToBezierPathElement:
                path.move(to: points[0])
            case .lineToBezierPathElement:
                path.addLine(to: points[0])
            case .curveToBezierPathElement:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePathBezierPathElement:
                path.closeSubpath()
            }
        }

        return path
    }

    convenience init(points: [NSPoint]) {
        self.init()
        drawLines(points)
    }

    convenience init(points: NSPoint...) {
        self.init(points: points)
    }

    func drawLines(_ points: [NSPoint]) {
        points.first.map(self.move(to:))
        points.dropFirst().forEach(self.line)
    }

    func drawLines(_ points: NSPoint...) {
        drawLines(points)
    }
}
