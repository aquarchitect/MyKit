//
//  TextView.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/25/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public class TextView: UIView {

    // MARK: Property

    public private(set) lazy var placeholder: UILabel = {
        let label = UILabel()
        label.textColor = .lightGrayColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(label, atIndex: 0)

        _ = ["H:|-[label]-|", "V:|-[label]-|"].map(self.addConstraintsWithVisualFormat(["label": label]))

        return label
        }()

    public private(set) lazy var textBox: UITextView = {
        let view = UITextView()
        view.returnKeyType = .Done
        view.keyboardAppearance = .Dark
        view.backgroundColor = .clearColor()
        view.textContainer.lineFragmentPadding = 0
        view.textContainerInset = UIEdgeInsetsMake(0, 0, 0, self.layoutMargins.right)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addObserver(self, forKeyPath: "contentSize", options: .New, context: nil)
        self.addSubview(view)

        return view
        }()

    // MARK: Deinitialization

    deinit { textBox.removeObserver(self, forKeyPath: "contentSize") }

    // MARK: System methods

    public override func intrinsicContentSize() -> CGSize {
        let width = textBox.contentSize.width + self.layoutMargins.horizontal
        let height = textBox.contentSize.height + self.layoutMargins.vertical

        return CGSizeMake(width, height)
    }

    public override func updateConstraints() {
        _ = ["H:|-[textBox]-|", "V:|-[textBox]|"].map(self.addConstraintsWithVisualFormat(["textBox": textBox]))

        super.updateConstraints()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let diff = textBox.contentSize.height - textBox.bounds.height
        if diff < 0 { textBox.contentOffset.y = diff / 2 }
    }

    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        self.setNeedsLayout()
        self.invalidateIntrinsicContentSize()
    }
}