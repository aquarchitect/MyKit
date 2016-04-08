//
//  CGPoint+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

public func CGPointDistanceToPoint(p1: CGPoint, _ p2: CGPoint) -> CGFloat {
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
}

public extension CGPoint {

    /**
     * Return a point by shifting origins toward self
     */
    public func shiftToCoordinate(point: CGPoint) -> CGPoint {
        return CGPointMake(self.x - point.x, self.y - point.y)
    }
}