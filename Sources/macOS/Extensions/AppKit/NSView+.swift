// 
// NSView+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
// 

import AppKit

public extension NSView {

    func snapshotImage() -> NSImage? {
        return NSImage(size: self.bounds.size).then {
            self.bitmapImageRepForCachingDisplay(in: self.bounds)?
                .then { self.cacheDisplay(in: self.bounds, to: $0) }
                .then($0.addRepresentation(_:))
        }
    }

    func snapshotView() -> NSImageView? {
        guard let image = snapshotImage() else { return nil }

        return NSImageView().then {
            $0.frame = self.bounds
            $0.image = image
        }
    }
}
