// 
// NSView+.swift
// MyKit
// 
// Created by Hai Nguyen on 1/23/17.
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

    func position(at edge: CGRectEdge) {
        switch edge {
        case .minXEdge: self.frame.origin.x -= self.bounds.width
        case .maxXEdge: self.frame.origin.x += self.bounds.width
        case .minYEdge: self.frame.origin.y -= self.bounds.height
        case .maxYEdge: self.frame.origin.y += self.bounds.height
        }
    }
}
