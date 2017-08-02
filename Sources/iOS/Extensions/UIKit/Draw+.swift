// 
// Draw+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import UIKit

/// Return an image by rendering in a specific context.
///
/// ```
/// // render an image from UILabel
///
/// let image = UILabel().then {
///     $0.text = "+"
///     $0.textAlignmnet = .Center
/// }.andThen {
///     render(size: $0.bounds.size, opaque: true, with: $0.layer.render(in:))
/// }
/// ```
///
/// - Parameter size: The size of output image.
/// - Parameter opaque: The bit-map opaque flag.
/// - Parameter render: Custom rendering block within a graphic context.
///
/// - Returns: An image object from rendering block
public func render(size: CGSize, opaque: Bool, in block: (CGContext) -> Void) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, opaque, 0)

    if let context = UIGraphicsGetCurrentContext() { block(context) }
    let image = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext()
    
    return image
}

public func render(size: CGSize, region: CGRect, withTileSize tileSize: CGSize, and prefix: String) {
    let enumerator = CGRect(origin: .zero, size: size)
        .slices(region, intoTilesOf: tileSize)

    for tile in enumerator {
        let name = "\(prefix)_\(tile.row)_\(tile.column).png"

        FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first
            .map({ $0.appendingPathComponent(name) })
            .flatMap({ UIImage(contentsOfFile: $0.path) })?
            .draw(in: tile.rect)
    }
}
