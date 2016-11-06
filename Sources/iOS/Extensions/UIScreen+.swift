/*
 * UIScreen+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

public extension UIScreen {

    var proportionalWidth: CGFloat {
        if case .compact = self.traitCollection.horizontalSizeClass {
            return self.bounds.width
        } else {
            return min(self.bounds.width, self.bounds.height) * 2/3
        }
    }
}
