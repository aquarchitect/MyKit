// 
// CGPoint+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import CoreGraphics

public extension CGPoint {

    func distance(from point: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }

    /// Return a point by shifting origins toward self
    func convertToCoordinate(of point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - point.x, y: self.y - point.y)
    }
    
    func center(with point: CGPoint) -> CGPoint {
        return CGPoint(
            x: (self.x + point.x)/2,
            y: (self.y + point.y)/2
        )
    }
}
