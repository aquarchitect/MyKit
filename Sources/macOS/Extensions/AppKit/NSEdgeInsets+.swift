// 
// NSEdgeInsets+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
// 

import AppKit

#if !swift(>=4.0)
public typealias NSEdgeInsets = EdgeInsets
#endif
    
public extension NSEdgeInsets {

    var vertical: CGFloat {
        return self.top + self.bottom
    }

    var horizontal: CGFloat {
        return self.left + self.right
    }

    init(sideLength: CGFloat) {
        self.init(
            top: sideLength,
            left: sideLength,
            bottom: sideLength,
            right: sideLength
        )
    }
}
