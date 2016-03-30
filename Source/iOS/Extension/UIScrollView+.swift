//
//  UIScrollView+.swift
//  MyKit
//
//  Created by Hai Nguyen on 11/6/15.
//
//

public extension UIScrollView {

    /// Bottom content offset takes into account contentInset
    final var bottomContentOffset: CGPoint {
        let x = max(self.contentSize.width - self.bounds.width + self.contentInset.right, 0)
        let y = max(self.contentSize.height - self.bounds.height + self.contentInset.bottom, 0)
        return CGPointMake(x, y)
    }
}