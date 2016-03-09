//
//  StackView.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/25/15.
//  
//

public class StackView: UIView {

    /// spacing between subviews
    public var spacing: CGFloat = 0

    private let layoutAxis: UILayoutConstraintAxis
    private var managedConstraints = [NSLayoutConstraint]()

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init (layoutAxis: UILayoutConstraintAxis) {
        self.layoutAxis = layoutAxis

        super.init(frame: CGRectZero)
        super.translatesAutoresizingMaskIntoConstraints = false
    }

    public override func didAddSubview(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false

        ["\(layoutAxis.opposite.suffix):|-[subview]-|"].forEach(self.addConstraintsWithVisualFormat(["subview": subview]))
        self.setNeedsUpdateConstraints()
    }

    public override func willRemoveSubview(subview: UIView) {
        self.setNeedsUpdateConstraints()
    }

    public override func updateConstraints() {
        if self.subviews.count > 0 {
            self.removeConstraints(managedConstraints)

            var format = "\(layoutAxis.opposite.suffix):|-"
            var dict = [String: AnyObject]()

            for (index, view) in (self.subviews as [UIView]).enumerate() {
                let key = "subview\(index)"
                format += index == 0 ? "[\(key)]" : "-\(spacing)-[\(key)]"
                dict[key] = view
            }

            format += "-|"

            managedConstraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: [], metrics: nil, views: dict)
            self.addConstraints(managedConstraints)
        }
        
        super.updateConstraints()
    }
}

private extension UILayoutConstraintAxis {

    var suffix: Character {
        switch self {

        case .Horizontal: return "H"
        case .Vertical: return "V"
        }
    }

    var opposite: UILayoutConstraintAxis {
        switch self {

        case .Horizontal: return .Vertical
        case .Vertical: return .Horizontal
        }
    }
}