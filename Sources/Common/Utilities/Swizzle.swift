/*
 * Swizzle.swift`
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

/// Swizzles original method of a reference type.
///
/// - parameter type:             class name
/// - parameter originalSelector: name of original method
/// - parameter swizzledSelector: name of replacement
/**
```swift
import UIKit

extension UIView {

    struct Layout {

        typealias Handler = @convention(block) () -> Void
        static var token = "Layout"
    }

    func overrideLayoutSubviews(handler: @escaping () -> Void) {
        objc_setAssociatedObject(self,
                                 &Layout.token,
                                 handler as Layout.Handler,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }

    func swizzledLayoutSubviews() {
        self.swizzledLayoutSubviews()
        (objc_getAssociatedObject(self, &Layout.token) as? Layout.Handler)?()
    }

    open override class func initialize() {
        /*
         * Since `dispatch_once` is deprecated in Swift 3.0,
         * this implementation is the alternative.
         */
        let swizzle: Void = {
            MyKit.swizzle(type: UIView.self,
                          original: #selector(layoutSubviews),
                          swizzled: #selector(swizzledLayoutSubviews))
        }()

        swizzle
    }
}
*/

public func swizzle(type: AnyClass, original originalSelector: Selector, swizzled swizzledSelector: Selector) {
    // get method objects
    let originalMethod = class_getInstanceMethod(type, originalSelector)
    let swizzledMethod = class_getInstanceMethod(type, swizzledSelector)

    // check whether original method has been swizzlled
    if class_addMethod(type,
                       originalSelector,
                       method_getImplementation(swizzledMethod),
                       method_getTypeEncoding(swizzledMethod)) {
        class_replaceMethod(type,
                            swizzledSelector,
                            originalMethod,
                            method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod,
                                       swizzledMethod)
    }
}

let test: Void = {
    _ = NSObject()
}()


