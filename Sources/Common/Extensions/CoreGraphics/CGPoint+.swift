/*
 * CGPoint+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CoreGraphics

public extension CGPoint {

#if swift(>=3.0)
    func distance(from point: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }
#else
    func distanceFromPoint(point: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }
#endif

    /**
     * Return a point by shifting origins toward self
     */
#if swift(>=3.0)
    func convertToCoordinate(ofOrigin point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - point.x, y: self.y - point.y)
    }
#else
    func convertToCoordinateOfOrigin(point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - point.x, y: self.y - point.y)
    }
#endif
}
