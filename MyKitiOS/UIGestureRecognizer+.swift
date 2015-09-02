//
//  UIGestureRecognizer+.swift
//  MyKit
//
//  Created by Hai Nguyen on 9/1/15.
//
//

public extension UIGestureRecognizer {

    private struct Action {

        typealias Handle = @convention(block) UIGestureRecognizer -> Void
        static var Token = "Action"
    }

    final func addAction(handle: UIGestureRecognizer -> Void) {
        let object: AnyObject = unsafeBitCast(handle as Action.Handle, AnyObject.self)
        objc_setAssociatedObject(self, &Action.Token, object, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.addTarget(self, action: "controlHandle:")
    }

    internal func controlHandle(sender: UIGestureRecognizer) {
        unsafeBitCast(objc_getAssociatedObject(self, &Action.Token), Action.Handle.self)(sender)
    }
}