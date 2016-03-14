//
//  UIView+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

public extension UIView {

    /**
    Add constraints by using visual format and currying
    
    ```swift
        ["H:[self(30)]", "V:[self(50)]"].forEach(self.addConstraintsWithVisualFormat(["self": self]))
    ```
    */
    public func addConstraintsWithVisualFormat(views: [String: UIView], metrics: [String: CGFloat] = [:]) -> (String -> Void) {
        return { self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat($0, options: [], metrics: metrics, views: views)) }
    }

    // :nodoc:
    public func addConstraint(item view1: UIView, attribute attr1: NSLayoutAttribute, relatedBy relation: NSLayoutRelation, toItem view2: UIView?, attribute attr2: NSLayoutAttribute, multiplier: CGFloat, constant c: CGFloat, priority: Float = UILayoutPriorityRequired) {
        return NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: c).then {
                $0.priority = priority
                self.addConstraint($0)
            }
    }
}