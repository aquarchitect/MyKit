// 
// UIBezierPath+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import UIKit

public extension UIBezierPath {

    convenience init(points: [CGPoint]) {
        self.init()
        drawLines(points)
    }

    convenience init(points: CGPoint...) {
        self.init(points: points)
    }

    func drawLines(_ points: [CGPoint]) {
        precondition(points.count > 1, "Invalid number of points!")

        self.move(to: points.first!)
        points.dropFirst().forEach(self.addLine)
    }

    func drawLines(_ points: CGPoint...) {
        drawLines(points)
    }
}

public extension UIBezierPath {

    var outlineStroke: UIBezierPath {
        return CGPath(__byStroking: self.cgPath,
                      transform: nil,
                      lineWidth: self.lineWidth,
                      lineCap: self.lineCapStyle,
                      lineJoin: self.lineJoinStyle,
                      miterLimit: self.miterLimit)
            .flatMap(UIBezierPath.init(cgPath:))
            ?? UIBezierPath()
    }
}
