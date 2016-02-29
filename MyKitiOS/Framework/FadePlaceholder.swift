//
//  FadePlaceholder.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/5/16.
//
//

public protocol FadePlaceholder: class {

    var placeholder: UILabel { get }
}

extension FadePlaceholder {

    public func animatePlaceholder(alpha: CGFloat) {
        UIView.animateWithDuration(0.25) { [unowned placeholder] in
            placeholder.alpha = alpha
        }
    }

    public func delayPlaceholderAnimation(textView: UITextView) {
        if placeholder.alpha == 1 && !textView.text.isEmpty { animatePlaceholder(0) }
        if placeholder.alpha == 0 && textView.text.isEmpty { animatePlaceholder(1) }
    }
}