//
//  UIControl+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension UIControl {

    private struct Key { static var action = "Action" }

    private typealias Handle = @convention(block) UIControl -> Void

    final func addAction(handle: UIControl -> Void, forControlEvents events: UIControlEvents) {
        let object: AnyObject = unsafeBitCast(handle as Handle, AnyObject.self)
        objc_setAssociatedObject(self, &Key.action, object, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.addTarget(self, action: "controlHandle:", forControlEvents: events)
    }

    internal func controlHandle(sender: UIControl) {
        unsafeBitCast(objc_getAssociatedObject(self, &Key.action), Handle.self)(sender)
    }
}