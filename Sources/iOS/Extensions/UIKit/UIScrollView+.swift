// 
// UIScrollView+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import UIKit

/// :nodoc:
public extension UIScrollView {

    var contentOffsetRange: (lowerBound: CGPoint, upperBound: CGPoint) {
        let minX = -self.contentInset.left
        let minY = -self.contentInset.top
        let minContentOffset = CGPoint(x: minX, y: minY)

        let maxX = max(self.contentSize.width - self.bounds.width + self.contentInset.right, 0)
        let maxY = max(self.contentSize.height - self.bounds.height + self.contentInset.bottom, 0)
        let maxContentOffset = CGPoint(x: maxX, y: maxY)

        return (minContentOffset, maxContentOffset)
    }
}
