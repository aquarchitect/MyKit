//
//  Swizzling.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

private enum Exception: ErrorType {

    case MethodNotFound(Selector)
}

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
            do { try swizzle(UIView.self, original: "layoutSubviews", swizzled: "swizzledLayoutSubviews") }
            catch { print(error) }
        }
    }
```
*/
public func swizzle(type: AnyClass, original: Selector, swizzled: Selector) throws {
    // double check string method typo
    try [original, swizzled].forEach {
        if !class_respondsToSelector(type, $0) {
            throw Exception.MethodNotFound($0)
        }
    }

    // get method objects
    let originalMethod = class_getInstanceMethod(type, original)
    let swizzledMethod = class_getInstanceMethod(type, swizzled)

    // check whether original method has been swizzlled
    if class_addMethod(type, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) {
        class_replaceMethod(type, swizzled, originalMethod, method_getTypeEncoding(originalMethod))
    } else { method_exchangeImplementations(originalMethod, swizzledMethod) }
}