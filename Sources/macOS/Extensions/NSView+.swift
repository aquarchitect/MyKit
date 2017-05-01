// 
// NSView+.swift
// MyKit
// 
// Created by Hai Nguyen on 1/23/17.
// Copyright (c) 2017 Hai Nguyen.
// 

import AppKit

public extension NSView {

    func snapshotView() -> NSImageView? {
        return self.bitmapImageRepForCachingDisplay(in: self.bounds)?
            .then { self.cacheDisplay(in: self.bounds, to: $0) }
            .andThen { bitmap in
                NSImageView().then {
                    $0.frame = self.bounds
                    $0.image = NSImage(size: self.bounds.size)
                    $0.image?.addRepresentation(bitmap)
                }
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
