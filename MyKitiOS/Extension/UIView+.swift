//
//  UIView+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension UIView {

    private struct Layout {

        typealias Handler = @convention(block) Void -> Void
        static var Token = "Layout"
    }

    public func overrideLayoutSubviews(block: Void -> Void) {
        let object: AnyObject = unsafeBitCast(block as Layout.Handler, AnyObject.self)
        objc_setAssociatedObject(self, &Layout.Token, object, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }

    public override class func initialize() {
        struct Static { static var token: dispatch_once_t = 0 }

        dispatch_once(&Static.token) {
            swizzle(UIView.self, original: "layoutSubviews", swizzled: "swizzledLayoutSubviews")
        }
    }

    internal func swizzledLayoutSubviews() {
        self.swizzledLayoutSubviews()
        if let object = objc_getAssociatedObject(self, &Layout.Token) {
            _ = unsafeBitCast(object, Layout.Handler.self)()
        }
    }

    public func addConstraintsWithVisualFormat(views: [String: UIView], metrics: [String: AnyObject]? = nil)(format: String) {
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: [], metrics: metrics, views: views))
    }

    public func addConstraint(item view1: AnyObject, attribute attr1: NSLayoutAttribute, relatedBy relation: NSLayoutRelation, toItem view2: AnyObject?, attribute attr2: NSLayoutAttribute, multiplier: CGFloat, constant c: CGFloat) {
        let constraint = NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: c)
        self.addConstraint(constraint)
    }
}