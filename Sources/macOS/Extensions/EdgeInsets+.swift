/*
 * EdgeInsets+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2017 Hai Nguyen.
 */

import AppKit

public extension EdgeInsets {

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
