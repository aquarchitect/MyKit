//
//  TextView.swift
//  MyKit
//
//  Created by Hai Nguyen on 9/3/15.
//
//

public class TextView: UIControl {

    public private(set) lazy var textBox: UITextView = {
        let view = UITextView()
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clearColor()
        view.textContainer.lineFragmentPadding = 0
        view.textContainerInset = UIEdgeInsetsZero
        view.textContainerInset.right = self.layoutMargins.right
        view.keyboardAppearance = .Dark
        view.enablesReturnKeyAutomatically = true
        view.addObserver(self, forKeyPath: "contentSize", options: [.Initial, .New], context: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        return view
    }()

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = .whiteColor()

        self.addConstraintsWithVisualFormat(["textBox": textBox])(format: "V:|-[textBox]-|")

        let attributes = [(.Left, .LeftMargin), (.Right, .Right), (.Top, .TopMargin), (.Bottom, .BottomMargin)] as [(NSLayoutAttribute, NSLayoutAttribute)]
        attributes.forEach {
            let constraint = NSLayoutConstraint(item: self.textBox, attribute: $0, relatedBy: .Equal, toItem: self, attribute: $1, multiplier: 1, constant: 0)
            constraint.priority = 800
            self.addConstraint(constraint)
        }
    }

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