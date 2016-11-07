/*
 * NSBezierPath+.swift
 * MyKit
 *
 * Created by Hai Nguyen
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

    func drawLines(_ points: [NSPoint]) {
        precondition(points.count > 1, "Invalid number of points!")

        self.move(to: points.first!)
        points.dropFirst().forEach(self.line)
    }

    func drawLines(_ points: NSPoint...) {
        drawLines(points)
    }
}
