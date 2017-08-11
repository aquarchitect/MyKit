//
// TilingImageView.swift
// MyKit
//
// Created by Hai Nguyen on 8/11/17.
// Copyright (c) 2017 Hai Nguyen.
//

import UIKit

open class TilingImageView: UIView {

    // MARK: Properties

    open var cacheURL = FileManager.default
        .urls(for: .cachesDirectory, in: .userDomainMask)
        .first

    open var imagePrefix: String = ""

    override open class var layerClass: AnyClass {
        return CATiledLayer.self
    }

    // MARK: System Methods

    override open func draw(_ rect: CGRect) {
        guard !imagePrefix.isEmpty else {
            return Swift.print("Image prefix requires a value other than empty!")
        }

        guard let cacheURL = self.cacheURL,
            let tileSize = (self.layer as? CATiledLayer)?.tileSize
            else { return }

        render(
            region: rect, of: self.bounds.size,
            from: cacheURL,
            withTileSize: tileSize,
            andPrefix: imagePrefix
        )
    }
}
