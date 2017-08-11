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
