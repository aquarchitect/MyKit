/*
 * GrowingTextView.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

#if swift(>=3.0)
open class GrowingTextView: UIControl {

    // MARK: Property

    open override var intrinsicContentSize: CGSize {
        let width = textBox.contentSize.width + self.layoutMargins.horizontal
        let height = textBox.contentSize.height + self.layoutMargins.vertical

        return CGSize(width: width, height: height)
    }

    open let textBox = UITextView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.textContainer.lineFragmentPadding = 0
        $0.textContainerInset = .zero
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Initialization

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.preservesSuperviewLayoutMargins = true
        super.addSubview(textBox)

        textBox.addObserver(self, forKeyPath: "contentSize", options: [.initial, .new], context: nil)

        [(.left, .leftMargin),
         (.right, .right),
         (.top, .topMargin),
         (.bottom, .bottomMargin)]
            .map { NSLayoutConstraint(item: textBox, attribute: $0, relatedBy: .equal, toItem: self, attribute: $1, multiplier: 1, constant: 0).then { $0.priority = 800 }}
            .activate()
    }

    deinit { textBox.removeObserver(self, forKeyPath: "contentSize") }

    // MARK: System Method

    open override func layoutMarginsDidChange() {
        self.invalidateIntrinsicContentSize()
        super.layoutMarginsDidChange()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        textBox.then {
            let diff = $0.contentSize.height - $0.bounds.height
            diff < 0 ? $0.contentInset.top = diff / 2 : ()
        }
    }

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.invalidateIntrinsicContentSize()
        self.setNeedsLayout()
    }
}
#else
public class GrowingTextView: UIControl {

    // MARK: Property

    public let textBox = UITextView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.textContainer.lineFragmentPadding = 0
        $0.textContainerInset = UIEdgeInsetsZero
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Initialization

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.preservesSuperviewLayoutMargins = true
        super.addSubview(textBox)

        textBox.addObserver(self, forKeyPath: "contentSize", options: [.Initial, .New], context: nil)

        [(.Left, .LeftMargin),
         (.Right, .Right),
         (.Top, .TopMargin),
         (.Bottom, .BottomMargin)]
            .map { NSLayoutConstraint(item: textBox, attribute: $0, relatedBy: .Equal, toItem: self, attribute: $1, multiplier: 1, constant: 0).then { $0.priority = 800 }}
            .activate()
    }

    deinit { textBox.removeObserver(self, forKeyPath: "contentSize") }

    // MARK: System Method

    public override func intrinsicContentSize() -> CGSize {
        let width = textBox.contentSize.width + self.layoutMargins.horizontal
        let height = textBox.contentSize.height + self.layoutMargins.vertical

        return CGSize(width: width, height: height)
    }

    public override func layoutMarginsDidChange() {
        self.invalidateIntrinsicContentSize()
        super.layoutMarginsDidChange()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        textBox.then {
            let diff = $0.contentSize.height - $0.bounds.height
            diff < 0 ? $0.contentInset.top = diff / 2 : ()
        }
    }

    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        self.invalidateIntrinsicContentSize()
        self.setNeedsLayout()
    }
}
#endif
