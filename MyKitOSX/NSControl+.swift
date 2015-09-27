//
//  NSControl+.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/19/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension NSControl {

    private struct Key { static var action = "Action" }
    private typealias Action = @convention(block) NSControl -> Void

    public func addAction(action: NSControl -> Void) {
        addActionForProperty(action, property: "action")
    }

    internal func addActionForProperty(action: NSControl -> Void, property: String) {
        let object = unsafeBitCast(action as Action, AnyObject.self)
        objc_setAssociatedObject(self, &Key.action, object, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.setValue("handleControl:", forKey: property)
        self.target = self
    }

    internal func handleControl(sender: NSControl) {
        let object = objc_getAssociatedObject(self, &Key.action)
        _ = unsafeBitCast(object, Action.self)(sender)
    }
}