//
// TilingImageView.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

import UIKit


open class TilingImageView: UIView {

    // MARK: Properties

    open var tileSize: CGSize = .zero {
        didSet {
            (self.layer as? CATiledLayer)?.tileSize = tileSize
        }
    }

    // `draw` method gets called asynchronously
    // while accessing `self.bounds.size` needs to be on
    // the main thread
    private var containerSize: CGSize = .zero

    open var cacheURL = FileManager.default
        .urls(for: .cachesDirectory, in: .userDomainMask)
        .first

    open var imagePrefix: String = ""

    override open class var layerClass: AnyClass {
        return CATiledLayer.self
    }

    // MARK: Initialization

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        tileSize = (self.layer as? CATiledLayer)?.tileSize ?? .zero
    }

    // MARK: System Methods

    open override func layoutSubviews() {
        super.layoutSubviews()

        containerSize = self.bounds.size
    }

    override open func draw(_ rect: CGRect) {
        guard !imagePrefix.isEmpty else {
            return Swift.print("Image prefix requires a value other than empty!")
        }

        guard let cacheURL = self.cacheURL else { return }

        render(
            region: rect,
            of: containerSize,
            from: cacheURL,
            withTileSize: tileSize,
            andPrefix: imagePrefix
        )
    }
}
