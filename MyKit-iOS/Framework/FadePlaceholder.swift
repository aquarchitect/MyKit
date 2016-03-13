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

    public func fadePlaceholderAlongsideWith(text: String) {
        let animation = { (alpha: CGFloat) in
            UIView.animateWithDuration(0.25) {
                self.placeholder.alpha = alpha
            }
        }

        if placeholder.alpha == 1 && !text.isEmpty { animation(0) }
        if placeholder.alpha == 0 && text.isEmpty { animation(1) }
    }
}