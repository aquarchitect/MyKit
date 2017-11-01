//
//  CGAffineTransform+.swift
//  MyKit
//
//  Created by Hai Nguyen on 10/31/17.
//

import CoreGraphics

public extension CGAffineTransform {
    
    init(scale: CGFloat) {
        self.init(scaleX: scale, y: scale)
    }
    
    init(translation: CGFloat) {
        self.init(translationX: translation, y: translation)
    }
}
