//
//  TextView.swift
//  MyKit
//
//  Created by Hai Nguyen on 9/3/15.
//
//

public class TextView: UIView {

    public let placeholder = UILabel()
    public let textBox = UITextView()

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = .whiteColor()

        placeholder.textColor = .lightGrayColor()
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(placeholder)

        textBox.backgroundColor = .clearColor()
        textBox.textContainer.lineFragmentPadding = 0
        textBox.textContainerInset = UIEdgeInsetsZero
        textBox.keyboardAppearance = .Dark
        textBox.returnKeyType = .Done
        textBox.delegate = self
        textBox.addObserver(self, forKeyPath: "contentSize", options: .New, context: nil)
        textBox.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textBox)

        ["H:|-[placeholder]-|", "V:|-[placeholder]-|", "H:|-[textBox]|", "V:|-[textBox]-|"].forEach(self.addConstraintsWithVisualFormat(["placeholder": placeholder, "textBox": textBox]))
    }

    deinit { textBox.removeObserver(self, forKeyPath: "contentSize") }

    public override func intrinsicContentSize() -> CGSize {
        let width = textBox.contentSize.width + self.layoutMargins.horizontal
        let height = textBox.contentSize.height + self.layoutMargins.vertical
        return CGSize(width: width, height: height)
    }

    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        self.invalidateIntrinsicContentSize()

        let diff = textBox.contentSize.height - textBox.bounds.height
        if diff < 0 { textBox.contentOffset.y = diff / 2 }
    }
}

extension TextView: UITextViewDelegate {

    public func textViewDidChange(textView: UITextView) {
        let animatePlaceholder = { alpha in
            UIView.animateWithDuration(0.1) { self.placeholder.alpha = alpha }
        }

        if placeholder.alpha == 1 && !textView.text.isEmpty { animatePlaceholder(0) }
        if placeholder.alpha == 0 && textView.text.isEmpty { animatePlaceholder(1) }
    }
}