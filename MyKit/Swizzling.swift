//
//  Swizzling.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public func swizzle(type: AnyClass, original: Selector, swizzled: Selector){
    assert(class_respondsToSelector(type, original), "Check on Original typo.")
    assert(class_respondsToSelector(type, swizzled), "Check on Swizzled typo.")

    let originalMethod = class_getInstanceMethod(type, original)
    let swizzledMethod = class_getInstanceMethod(type, swizzled)

    if class_addMethod(type, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) {
        class_replaceMethod(type, swizzled, originalMethod, method_getTypeEncoding(originalMethod))
    } else { method_exchangeImplementations(originalMethod, swizzledMethod) }
}