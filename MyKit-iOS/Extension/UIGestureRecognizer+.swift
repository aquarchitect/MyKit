//
//  UIGestureRecognizer+.swift
//  MyKit
//
//  Created by Hai Nguyen on 9/1/15.
//
//

public extension UIGestureRecognizer {

    private struct Action {

        typealias Handler = @convention(block) UIGestureRecognizer -> Void
        static var Token = "Action"
    }

    final func addAction(block: UIGestureRecognizer -> Void) {
        let object: AnyObject = unsafeBitCast(block as Action.Handler, AnyObject.self)
        objc_setAssociatedObject(self, &Action.Token, object, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.addTarget(self, action: "controlHandle:")
    }

    internal func controlHandle(sender: UIGestureRecognizer) {
        _ = unsafeBitCast(objc_getAssociatedObject(self, &Action.Token), Action.Handler.self)(sender)
    }
}