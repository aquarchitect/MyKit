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

    typealias Tile = (column: Int, row: Int, rect: CGRect)

    func slices(_ rect: CGRect, intoTilesOf size: CGSize) -> AnyIterator<Tile> {
        let firstColumn = Int(rect.minX/size.width)
        let lastColumn = Int(rect.maxX/size.width) + 1
        let firstRow = Int(rect.minY/size.height)
        let lastRow = Int(rect.maxY/size.height) + 1

        var i = firstColumn, j = firstRow

        return AnyIterator<Tile> {
            while i < lastColumn && j < lastRow {
                let rect = CGRect(
                    x: size.width * CGFloat(i),
                    y: size.height * CGFloat(j),
                    width: size.width,
                    height: size.height
                )

                let tile: Tile = (i, j, self.intersection(rect))

                if i == lastColumn - 1 {
                    i = firstColumn; j += 1
                } else {
                    i += 1
                }

                if tile.rect.isEmpty {
                    continue
                } else {
                    return tile
                }
            }
            
            return nil
        }
    }
}
