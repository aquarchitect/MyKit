//
// TilingContainerView.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

import UIKit

open class TilingContainerView: UIView {

    // MARK: Properties

    fileprivate let lowResolutionImageView = UIImageView().then {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.contentMode = .scaleAspectFit
    }

    fileprivate let highResolutionImageView = TilingImageView().then {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    // MARK: Initialization

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        ([lowResolutionImageView, highResolutionImageView] as [UIView]).forEach {
            $0.frame = self.bounds
            self.addSubview($0)
        }
    }
}

public extension TilingContainerView {

    var tileSize: CGSize {
        get { return highResolutionImageView.tileSize }
        set { highResolutionImageView.tileSize = newValue }
    }

    var cacheURL: URL? {
        get { return highResolutionImageView.cacheURL }
        set { highResolutionImageView.cacheURL = newValue }
    }

    var imagePrefix: String {
        get { return highResolutionImageView.imagePrefix }
        set { highResolutionImageView.imagePrefix = newValue }
    }

    var lowResolutionImage: UIImage? {
        get { return lowResolutionImageView.image }
        set { lowResolutionImageView.image = newValue }
    }
}
