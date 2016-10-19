/*
 * UILabel+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import UIKit

/// :nodoc:
public extension UILabel {

    // FIXME: unable to make it work in an app

#if swift(>=3.0)
    func boundingRectForCharacters(in range: NSRange) -> CGRect {
        guard let attributedText = self.attributedText else { return CGRect.null }
        let layoutManager = NSLayoutManager()

        // unable to use `then` because of text storage reference
        NSTextStorage(attributedString: attributedText).addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(size: bounds.size)
            .then { $0.lineFragmentPadding = 0 }
            .then(layoutManager.addTextContainer)

        var glyphRange = NSRange()

        // Convert the range for glyphs.
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)
        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
#else
    func boundingRectForCharactersInRange(range: NSRange) -> CGRect {
        guard let attributedText = self.attributedText else { return CGRect.null }
        let layoutManager = NSLayoutManager()

        // unable to use `then` because of text storage reference
        NSTextStorage(attributedString: attributedText).addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(size: bounds.size)
            .then { $0.lineFragmentPadding = 0 }
            .then(layoutManager.addTextContainer)

        var glyphRange = NSRange()

        // Convert the range for glyphs.
        layoutManager.characterRangeForGlyphRange(range, actualGlyphRange: &glyphRange)
        return layoutManager.boundingRectForGlyphRange(glyphRange, inTextContainer: textContainer)
    }
#endif
}
