/*
 * NSEdgeInsets.swift
 * MyKit
 *
 * Created by Hai Nguyen on 11/4/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

import Foundation

public extension EdgeInsets {

    public init(sideLength length: CGFloat) {
        self.init(top: length, left: length, bottom: length, right: length)
    }
}
