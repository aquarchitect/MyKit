/*
 * Swizzle.swift`
 * MyKit
 *
 * Copyright (c) 2015–2016 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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