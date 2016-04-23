//
//  NSLayoutConstraint+.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/16/16.
//  
//

public extension NSLayoutConstraint {

    public convenience init(view view1: UIView, attribute attr1: NSLayoutAttribute, relatedBy relation: NSLayoutRelation, toView view2: UIView?, attribute attr2: NSLayoutAttribute, multiplier: CGFloat, constant c: CGFloat, priority: UILayoutPriority = UILayoutPriorityRequired) {
        self.init(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: c)
        self.priority = priority
    }

    public static func constraintsWithVisualFormat(format: String, views: [String: UIView], metrics: [String: CGFloat]? = nil) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat(format, options: [], metrics: metrics, views: views)
    }
}

public extension Array where Element: NSLayoutConstraint {

    public func activate() {
        NSLayoutConstraint.activateConstraints(self)
    }

    public func deactivate() {
        NSLayoutConstraint.deactivateConstraints(self)
    }
}