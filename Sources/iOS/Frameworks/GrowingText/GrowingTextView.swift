//
//  GrowingTextView.swift
//  MyKit
//
//  Created by Hai Nguyen on 9/3/15.
//
//

public class GrowingTextView: UIControl {

    // MARK: Property

    public let textBox = UITextView().then {
        $0.font = .systemFontOfSize(17)
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clearColor()
        $0.textContainer.lineFragmentPadding = 0
        $0.textContainerInset = UIEdgeInsetsZero
        $0.enablesReturnKeyAutomatically = true
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

        [(.Left, .LeftMargin), (.Right, .Right), (.Top, .TopMargin), (.Bottom, .BottomMargin)].map { NSLayoutConstraint(view: textBox, attribute: $0, relatedBy: .Equal, toView: self, attribute: $1, multiplier: 1, constant: 0, priority: 800) }.activate()
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

        let diff = textBox.contentSize.height - textBox.bounds.height
        diff < 0 ? textBox.contentInset.top = diff / 2 : ()
    }

    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        self.invalidateIntrinsicContentSize()
        self.setNeedsLayout()
    }
}