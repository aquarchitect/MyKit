//
//  Swizzling.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

import Foundation

/**
Swizzles original method.

- parameter type: Class name.
- parameter original: Name of original method.
- parameter swizzled: Name of replaced method.

```swift
    extension UIView {

        private struct Layout {

            typealias Handler = @convention(block) Void -> Void
            static var Token = "Layout"
        }

    func overrideLayoutSubviews(block: Void -> Void) {
        let object: AnyObject = unsafeBitCast(block as Layout.Handler, AnyObject.self)
        objc_setAssociatedObject(self, &Layout.Token, object, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }

    func swizzledLayoutSubviews() {
        self.swizzledLayoutSubviews()
    
        if let object = objc_getAssociatedObject(self, &Layout.Token) {
            _ = unsafeBitCast(object, Layout.Handler.self)()
        }
    }

    public override class func initialize() {
        struct Dispatch { static var token: dispatch_once_t = 0 }

        dispatch_once(&Dispatch.token) {
            swizzle(UIView.self, original: "layoutSubviews", swizzled: "swizzledLayoutSubviews")
        }
    }
```
*/
public func swizzle(type: AnyClass, original originalSelector: Selector, swizzled swizzledSelector: Selector) {
    // get method objects
    let originalMethod = class_getInstanceMethod(type, originalSelector)
    let swizzledMethod = class_getInstanceMethod(type, swizzledSelector)

    // check whether original method has been swizzlled
    if class_addMethod(type, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) {
        class_replaceMethod(type, swizzledSelector, originalMethod, method_getTypeEncoding(originalMethod))
    } else { method_exchangeImplementations(originalMethod, swizzledMethod) }
}