//
//  UIView+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension UIView {

    final func addConstraintsWithVisualFormat(views: [String: UIView], metrics: [String: AnyObject]? = nil)(format: String) {
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: [], metrics: metrics, views: views))
    }
}