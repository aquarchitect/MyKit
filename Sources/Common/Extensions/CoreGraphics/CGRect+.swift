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

public extension CGRect {

    func slicesIntoTiles(of size: CGSize) -> AnyIterator<CGRect> {
        let rows = Int(self.size.height / size.height) + 1
        let columns = Int(self.size.width / size.width) + 1

        var i = 0, j = 0

        return AnyIterator<CGRect> {
            while i < columns && j < rows {
                let rect = CGRect(
                    x: size.width * CGFloat(i),
                    y: size.height * CGFloat(j),
                    width: i == columns - 1 ? self.size.width.truncatingRemainder(dividingBy: size.width) : size.width,
                    height: j == rows - 1 ? self.size.height.truncatingRemainder(dividingBy: size.height) : size.height
                )

                if i == columns - 1 {
                    i = 0; j += 1
                } else {
                    i += 1
                }

                if rect.isEmpty {
                    continue
                } else {
                    return rect
                }
            }
            
            return nil
        }
    }
}
