/*
 * NSEdgeInsets.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import Foundation

public extension EdgeInsets {

    public init(sideLength length: CGFloat) {
        self.init(top: length, left: length, bottom: length, right: length)
    }
}
