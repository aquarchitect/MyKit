/*
 * CenteredClip.swift
 * MyKit
 *
 * Created by Hai Nguyen on 1/25/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import AppKit

open class CenteredClip: NSClipView {

    open override func constrainBoundsRect(_ proposedBounds: NSRect) -> NSRect {
        var constrainedBounds = super.constrainBoundsRect(proposedBounds)

        guard let size = self.documentView?.frame.size else {
            return constrainedBounds
        }

        // center horizontally if needed
        if size.width < proposedBounds.width {
            constrainedBounds.origin.x = floor((proposedBounds.width - size.width) / -2)
        }

        // center vertically if needed
        if size.height < proposedBounds.height {
            constrainedBounds.origin.y = floor((proposedBounds.height - size.height) / -2)
        }

        return constrainedBounds
    }
}
