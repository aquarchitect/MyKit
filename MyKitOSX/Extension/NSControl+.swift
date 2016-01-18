//
//  NSControl+.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/19/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension NSControl {

    private struct Key { static var action = "Action" }
    private typealias Handler = @convention(block) NSControl -> Void

    public func addAction(action: NSControl -> Void) {
        addActionForProperty(action, property: "action")
    }

    internal func addActionForProperty(block: NSControl -> Void, property: String) {
        let object = unsafeBitCast(block as Handler, AnyObject.self)
        objc_setAssociatedObject(self, &Key.action, object, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.setValue("handleControl:", forKey: property)
        self.target = self
    }

    internal func handleControl(sender: NSControl) {
        let object = objc_getAssociatedObject(self, &Key.action)
        _ = unsafeBitCast(object, Handler.self)(sender)
    }
}