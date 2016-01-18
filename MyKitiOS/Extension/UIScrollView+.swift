//
//  UIScrollView+.swift
//  MyKit
//
//  Created by Hai Nguyen on 11/6/15.
//
//

public extension UIScrollView {

    final var bottomContentOffset: CGPoint {
        return CGPoint(x: 0, y: max(self.contentSize.height - self.bounds.height, 0))
    }
}