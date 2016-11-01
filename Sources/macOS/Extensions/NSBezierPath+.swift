/*
 * NSBezierPath+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 10/31/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

import AppKit

public extension NSBezierPath {

    convenience init(points: [NSPoint]) {
        self.init()
        drawLines(points)
    }

    convenience init(points: NSPoint...) {
        self.init(points: points)
    }

    #if swift(>=3.0)
    func drawLines(_ points: [NSPoint]) {
        precondition(points.count > 1, "Invalid number of points!")

        self.move(to: points.first!)
        points.dropFirst().forEach(self.line)
    }

    func drawLines(_ points: NSPoint...) {
        drawLines(points)
    }
    #else
    func drawLines(points: [NSPoint]) {
        precondition(points.count > 1, "Invalid number of points!")

        self.moveToPoint(points.first!)
        points.dropFirst().forEach(self.lineToPoint)
    }

    func drawLines(points: NSPoint...) {
        drawLines(points)
    }
    #endif
}
