//
//  ActionInlining.swift
//  MyKit
//
//  Created by Hai Nguyen on 5/17/16.
//  
//

private var token = "Action"

public protocol ActionInlining: class {}

public extension ActionInlining {

    private func setAction(block: Self -> Void) {
        let obj: AnyObject = unsafeBitCast(ActionWrapper(f: block), AnyObject.self)
        objc_setAssociatedObject(self, &token, obj, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
}

internal extension NSObject {

    func handleBlock() {
        unsafeBitCast(objc_getAssociatedObject(self, &token), ActionWrapper.self).f(self)
    }
}

#if os(iOS)
extension UIControl: ActionInlining {}

public extension ActionInlining where Self: UIControl {

    public final func addAction(block: Self -> Void, forControlEvents events: UIControlEvents) {
        self.setAction(block)
        self.addTarget(self, action: #selector(handleBlock), forControlEvents: events)
    }
}
#endif

#if os(iOS)
extension UIGestureRecognizer: ActionInlining {}

public extension ActionInlining where Self: UIGestureRecognizer {

    public final func addAction(block: Self -> Void) {
        self.setAction(block)
        self.addTarget(self, action: #selector(handleBlock))
    }
}
#endif