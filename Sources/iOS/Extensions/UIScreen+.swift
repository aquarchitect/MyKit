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
        let ratio: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 1 : 2/3
        return fmin(self.bounds.width, self.bounds.height) * ratio
    }
}
