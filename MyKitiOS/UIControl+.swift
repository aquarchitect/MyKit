//
//  UIControl+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension UIControl {

    private struct Action {

        typealias Handle = @convention(block) UIControl -> Void
        static var Token = "Action"
    }

    final func addAction(handle: UIControl -> Void, forControlEvents events: UIControlEvents) {
        let object: AnyObject = unsafeBitCast(handle as Action.Handle, AnyObject.self)
        objc_setAssociatedObject(self, &Action.Token, object, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.addTarget(self, action: "controlHandle:", forControlEvents: events)
    }

    internal func controlHandle(sender: UIControl) {
        _ = unsafeBitCast(objc_getAssociatedObject(self, &Action.Token), Action.Handle.self)(sender)
    }
}