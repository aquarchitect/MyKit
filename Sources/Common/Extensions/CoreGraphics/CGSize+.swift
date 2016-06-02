//
//  CGSize+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

import CoreGraphics

public extension CGSize {

    init(sideLength: CGFloat) {
        self.init(width: sideLength, height: sideLength)
    }
}