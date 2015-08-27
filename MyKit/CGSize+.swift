//
//  CGSize+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension CGSize {

    init(sideLength: CGFloat) {
        self.init(width: sideLength, height: sideLength)
    }
}