//
//  TextView.swift
//  MyKit
//
//  Created by Hai Nguyen on 9/3/15.
//
//

public class TextView: UIView {

    public let textBox = UITextView()

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = .whiteColor()

        textBox.backgroundColor = .clearColor()
        textBox.textContainer.lineFragmentPadding = 0
        textBox.textContainerInset = UIEdgeInsetsZero
        textBox.textContainerInset.right = self.layoutMargins.right
        textBox.keyboardAppearance = .Dark
        textBox.returnKeyType = .Done
        textBox.enablesReturnKeyAutomatically = true
        textBox.addObserver(self, forKeyPath: "contentSize", options: [.Initial, .New], context: nil)
        textBox.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textBox)

        ["H:|-[textBox]|", "V:|-[textBox]-|"].forEach(self.addConstraintsWithVisualFormat(["textBox": textBox]))
    }

    deinit { textBox.removeObserver(self, forKeyPath: "contentSize") }

    public override func intrinsicContentSize() -> CGSize {
        let width = textBox.contentSize.width + self.layoutMargins.horizontal
        let height = textBox.contentSize.height + self.layoutMargins.vertical
        return CGSize(width: width, height: height)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let diff = textBox.contentSize.height - textBox.bounds.height
        if diff < 0 { textBox.contentOffset.y = diff / 2 }
    }

    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        self.invalidateIntrinsicContentSize()
        self.setNeedsLayout()
    }
}