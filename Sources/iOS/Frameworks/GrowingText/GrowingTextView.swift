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

        [(.left, .leftMargin),
         (.right, .right),
         (.top, .topMargin),
         (.bottom, .bottomMargin)]
            .map { NSLayoutConstraint(item: textBox, attribute: $0, relatedBy: .equal, toItem: self, attribute: $1, multiplier: 1, constant: 0).then { $0.priority = 800 }}
            .activate()
    }

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

    // MARK: First Responder

    open override func becomeFirstResponder() -> Bool {
        return textBox.becomeFirstResponder()
    }

    open override func resignFirstResponder() -> Bool {
        return textBox.resignFirstResponder()
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

        [(.Left, .LeftMargin),
         (.Right, .Right),
         (.Top, .TopMargin),
         (.Bottom, .BottomMargin)]
            .map { NSLayoutConstraint(item: textBox, attribute: $0, relatedBy: .Equal, toItem: self, attribute: $1, multiplier: 1, constant: 0).then { $0.priority = 800 }}
            .activate()
    }

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

    // MARK: First Responder

    public override func becomeFirstResponder() -> Bool {
        return textBox.becomeFirstResponder()
    }

    public override func resignFirstResponder() -> Bool {
        return textBox.resignFirstResponder()
    }
}
#endif
