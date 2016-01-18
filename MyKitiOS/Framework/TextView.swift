//
//  TextView.swift
//  MyKit
//
//  Created by Hai Nguyen on 9/3/15.
//
//

public class TextView: UIControl {

    public let textBox = UITextView().setup {
        $0.font = .systemFontOfSize(17)
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clearColor()
        $0.textContainer.lineFragmentPadding = 0
        $0.textContainerInset = UIEdgeInsetsZero
        $0.enablesReturnKeyAutomatically = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.preservesSuperviewLayoutMargins = true
        super.addSubview(textBox)

        textBox.addObserver(self, forKeyPath: "contentSize", options: [.Initial, .New], context: nil)
        let attributes = [(.Left, .LeftMargin), (.Right, .Right), (.Top, .TopMargin), (.Bottom, .BottomMargin)] as [(NSLayoutAttribute, NSLayoutAttribute)]
        attributes.forEach {
            let constraint = NSLayoutConstraint(item: self.textBox, attribute: $0, relatedBy: .Equal, toItem: self, attribute: $1, multiplier: 1, constant: 0)
            constraint.priority = 800
            self.addConstraint(constraint)
        }
    }

    deinit { textBox.removeObserver(self, forKeyPath: "contentSize") }

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
        if diff < 0 { textBox.contentOffset.y = diff / 2 }
    }

    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        self.invalidateIntrinsicContentSize()
        self.setNeedsLayout()
    }
}