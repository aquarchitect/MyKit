// 
// UIImage+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import UIKit

public extension UIImage {

    static func render(_ attributedString: NSAttributedString) -> UIImage? {
        let size = attributedString.size()
        let image: UIImage?

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        attributedString.draw(in: .init(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
