// 
// GrowingTextView.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import UIKit

/// Text view grows as user types. Its layout gets updated internally.
///
/// - Warning: If using this class inside `UICollectionView` cell or 
/// `UITableView` row, `contentSize` obserser should be removed
/// from `textBox` instance. This will allow to the layout
/// apply the size changes externally instead of internally.
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

        [
            (.left, .leftMargin),
            (.right, .right),
            (.top, .topMargin),
            (.bottom, .bottomMargin)
        ].map {
            NSLayoutConstraint(
                item: textBox,
                attribute: $0.0,
                relatedBy: .equal,
                toItem: self,
                attribute: $0.1,
                multiplier: 1,
                constant: 0
            ).then { $0.priority = UILayoutPriority(800) }
        }.activate()

        textBox.addObserver(
            self,
            forKeyPath: #keyPath(UITextView.contentSize),
            options: [.initial, .new],
            context: nil
        )
    }

    deinit {
        textBox.removeObserver(self, forKeyPath: #keyPath(UITextView.contentSize))
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

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.invalidateIntrinsicContentSize()
        self.setNeedsLayout()
    }

    // MARK: First Responder

    open override func becomeFirstResponder() -> Bool {
        return textBox.becomeFirstResponder()
    }

    open override func resignFirstResponder() -> Bool {
        return textBox.resignFirstResponder()
    }
}
