/*
 * UILabel+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import UIKit

public extension UILabel {

#if swift(>=3.0)
    static var shared: UILabel {
        struct Singleton {
            static let value = UILabel().then {
                $0.numberOfLines = 0
            }
        }

        return Singleton.value
    }
#else
    static func sharedInstance() -> UILabel {
        struct Singleton {
            static let value = UILabel().then {
                $0.numberOfLines = 0
            }
        }

        return Singleton.value
    }
#endif
}

/// :nodoc:
public extension UILabel {

    // FIXME: doesn't seem to work in production
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
