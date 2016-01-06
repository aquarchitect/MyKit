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

    public func animatePlaceholderAccordingly(textView: UITextView) {
        let animate = { (alpha: CGFloat) in
            UIView.animateWithDuration(0.25) { self.placeholder.alpha = alpha }
        }

        if placeholder.alpha == 1 && !textView.text.isEmpty { animate(0) }
        if placeholder.alpha == 0 && textView.text.isEmpty { animate(1) }
    }
}