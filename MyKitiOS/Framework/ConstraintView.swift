//
//  ConstraintView.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/26/15.
//
//

public struct ConstraintAxis {

    public let constant: CGFloat
    public let axis: UILayoutConstraintAxis

    public init(_ axis: UILayoutConstraintAxis, _ constant: CGFloat) {
        self.axis = axis
        self.constant = constant
    }
}

public protocol ConstraintView: class {

    static var FixedDirection: ConstraintAxis { get }
}

public extension ConstraintView where Self: UIView {

    public func commonInitialization() {
        let constraint = self.dynamicType.FixedDirection
        let attribute: NSLayoutAttribute

        switch constraint.axis {

        case .Horizontal:
            attribute = .Width
            self.frame.size.width = constraint.constant

        case .Vertical:
            attribute = .Height
            self.frame.size.height = constraint.constant
        }

        self.addConstraint(item: self, attribute: attribute, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: constraint.constant)
    }
}
