//
//  UIControl+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension UIControl {

    private struct Block {

        typealias Handler = @convention(block) UIControl -> Void
        static var Token = "Block"
    }

    final func addAction(block: UIControl -> Void, forControlEvents events: UIControlEvents) {
        let object: AnyObject = unsafeBitCast(block as Block.Handler, AnyObject.self)
        objc_setAssociatedObject(self, &Block.Token, object, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.addTarget(self, action: "handleControl:", forControlEvents: events)
    }

    internal func handleControl(sender: UIControl) {
        _ = unsafeBitCast(objc_getAssociatedObject(self, &Block.Token), Block.Handler.self)(sender)
    }
}