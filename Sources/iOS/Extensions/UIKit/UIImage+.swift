// 
// UIImage+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import UIKit

public extension UIImage {

    class func render(_ attributedString: NSAttributedString, scale: CGFloat = 1.0) -> UIImage? {
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let size = attributedString.size().applying(transform)
        let rect = CGRect(origin: .zero, size: size)
        let image: UIImage?

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        attributedString.draw(in: rect)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}

public extension UIImage {

    func slicesIntoTiles(of size: CGSize, andCachesTo url: URL, withPrefix prefix: String) {
        let rect = CGRect(origin: .zero, size: self.size)
        let imageRef = self.cgImage

        rect.slices(rect, intoTilesOf: size).forEach {
            let name = "\(prefix)_\($0.column)_\($0.row).png"

            try? imageRef?
                .cropping(to: $0.rect)
                .map(UIImage.init(cgImage:))
                .flatMap(UIImagePNGRepresentation(_:))?
                .write(to: url.appendingPathComponent(name))
        }
    }
}
