// 
// CGRect+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import CoreGraphics

public extension CGRect {

    var center: CGPoint {
        get {
            return CGPoint(x: self.midX, y: self.midY)
        }
        set {
            self.origin.x = newValue.x - self.width/2
            self.origin.y = newValue.y - self.height/2
        }
    }

    init(center: CGPoint, sideLength: CGFloat) {
        let origin = CGPoint(x: center.x - sideLength/2, y: center.y - sideLength/2)
        let size = CGSize(sideLength: sideLength)

        self.init(origin: origin, size: size)
    }

    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width/2, y: center.y - size.height/2)

        self.init(origin: origin, size: size)
    }
}
