//
//  UIScrollView+.swift
//  MyKit
//
//  Created by Hai Nguyen on 11/6/15.
//
//

public extension UIScrollView {

    final var limitedContentOffset: (min: CGPoint, max: CGPoint) {
        let minX = -self.contentInset.left
        let minY = -self.contentInset.top
        let minContentOffset = CGPointMake(minX, minY)

        let maxX = max(self.contentSize.width - self.bounds.width + self.contentInset.right, 0)
        let maxY = max(self.contentSize.height - self.bounds.height + self.contentInset.bottom, 0)
        let maxContentOffset = CGPointMake(maxX, maxY)

        return (minContentOffset, maxContentOffset)
    }
}