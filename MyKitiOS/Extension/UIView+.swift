//
//  UIView+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension UIView {

    // - MARK: Layout Subviews Swizzling

    private struct Layout {

        typealias Handler = @convention(block) Void -> Void
        static var Token = "Layout"
    }

    /// Override layout subviews by swizzling without subclassing
    public func overrideLayoutSubviews(block: Void -> Void) {
        let object: AnyObject = unsafeBitCast(block as Layout.Handler, AnyObject.self)
        objc_setAssociatedObject(self, &Layout.Token, object, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }

    // :nodoc:
    public override class func initialize() {
        struct Dispatch { static var token: dispatch_once_t = 0 }

        dispatch_once(&Dispatch.token) {
            swizzle(UIView.self, original: "layoutSubviews", swizzled: "swizzledLayoutSubviews")
        }
    }

    // :nodoc:
    public func swizzledLayoutSubviews() {
        self.swizzledLayoutSubviews()
        if let object = objc_getAssociatedObject(self, &Layout.Token) {
            _ = unsafeBitCast(object, Layout.Handler.self)()
        }
    }

    // - MARK: Auto-layout Constraints

    /**
    Add constraints by using visual format and currying
    
    ```swift
        ["H:[self(30)]", "V:[self(50)]"].forEach(self.addConstraintsWithVisualFormat(["self": self]))
    ```
    */
    public func addConstraintsWithVisualFormat(views: [String: UIView], metrics: [String: AnyObject]? = nil) -> (String -> Void) {
        return { self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat($0, options: [], metrics: metrics, views: views)) }
    }

    /// Add constraints directly
    public func addConstraint(item view1: AnyObject, attribute attr1: NSLayoutAttribute, relatedBy relation: NSLayoutRelation, toItem view2: AnyObject?, attribute attr2: NSLayoutAttribute, multiplier: CGFloat, constant c: CGFloat, priority: Float = UILayoutPriorityRequired) {
        let constraint = NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: c)
        constraint.priority = priority
        self.addConstraint(constraint)
    }
}