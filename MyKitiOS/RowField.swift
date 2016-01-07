//
//  RowField.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/5/16.
//
//

public protocol RowFieldDelegate: class {

    var selectedIndexPath: NSIndexPath? { get }
    func rowFieldDidChange(rowField: RowField)
}

public class RowField: UITableViewCell, FadePlaceholder {

    public weak var delegate: RowFieldDelegate?

    public var textBox: UITextView { return textView.textBox }
    public var placeholder: UILabel { return self.textLabel! }

    private let textView = TextView().setup {
        $0.backgroundColor = .clearColor()
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.textLabel?.textColor = .lightGrayColor()
        super.contentView.addSubview(textView)

        textBox.delegate = self
        ["H:|[textView]|", "V:|[textView]|"].forEach(self.contentView.addConstraintsWithVisualFormat(["textView": textView]))
    }

    public override func becomeFirstResponder() -> Bool {
        return textBox.becomeFirstResponder()
    }
}

extension RowField: UITextViewDelegate {

    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let condition = text == "\n"
        if condition { textView.resignFirstResponder() }
        return !condition
    }

    public func textViewDidChange(textView: UITextView) {
        animatePlaceholderAccordingly(textView)
        delegate?.rowFieldDidChange(self)
    }
}