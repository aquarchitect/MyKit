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

    func slicesIntoTiles(of size: CGSize, andCachesWithPrefix prefix: String) {
        guard let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }

        let imageRef = self.cgImage

        CGRect(origin: .zero, size: self.size)
            .slicesIntoTiles(of: size)
            .enumerated()
            .forEach {
                try? imageRef?
                    .cropping(to: $0.element)
                    .map(UIImage.init(cgImage:))
                    .flatMap(UIImagePNGRepresentation(_:))?
                    .write(to: cachesURL.appendingPathComponent("\(prefix)_\($0.offset).png"))
        }
    }
}
