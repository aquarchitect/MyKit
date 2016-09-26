/*
 * CGSize+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CoreGraphics

public extension CGSize {

    init(sideLength: CGFloat) {
        self.init(width: sideLength, height: sideLength)
    }
}
