//
//  ConstraintAxis.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/26/15.
//
//

public protocol ConstraintAxis: class {

    static var FixedDirection: (constant: CGFloat, axis: UILayoutConstraintAxis) { get }
}

public extension ConstraintAxis {

    public func lockAxis(view: UIView) -> NSLayoutConstraint {
        let attribute: NSLayoutAttribute
        let (constant, axis) = self.dynamicType.FixedDirection

        switch axis {

        case .Horizontal:
            attribute = .Width
            view.frame.size.width = constant

        case .Vertical:
            attribute = .Height
            view.frame.size.height = constant
        }

        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: constant).then { view.addConstraint($0) }
    }
}
