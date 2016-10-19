/*
 * UIScreen+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

public extension UIScreen {

    var propotionalWidth: CGFloat {
#if swift(>=3.0)
        if case .compact = self.traitCollection.horizontalSizeClass {
            return self.bounds.width
        } else {
            return min(self.bounds.width, self.bounds.height) * 2/3
        }
#else
        if case .Compact = self.traitCollection.horizontalSizeClass {
            return self.bounds.width
        } else {
            return min(self.bounds.width, self.bounds.height) * 2/3
        }
#endif
    }
}
