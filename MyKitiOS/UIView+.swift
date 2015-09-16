//
//  UIView+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension UIView {

    private struct Layout {

        typealias Handle = @convention(block) Void -> Void
        static var Token = "Layout"
    }

    public func overrideLayoutSubviews(handle: Void -> Void) {
        let object: AnyObject = unsafeBitCast(handle as Layout.Handle, AnyObject.self)
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
            unsafeBitCast(object, Layout.Handle.self)()
        }
    }
}

public extension UIView {

    final func addConstraintsWithVisualFormat(views: [String: UIView], metrics: [String: AnyObject]? = nil)(format: String) {
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: [], metrics: metrics, views: views))
    }
}