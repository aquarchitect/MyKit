//  
//  Swizzle.swift
//  MyKit
//  
//  Created by Hai Nguyen.
//  Copyright (c) 2015 Hai Nguyen.
//  

import Foundation

///  Swizzles original method of a reference type.
/// 
/// ```
/// import AppKit
/// 
/// extension NSView {
/// 
///     struct Layout {
/// 
///         typealias Handler = @convention(block) () -> Void
///         static var token = "Layout"
///     }
/// 
///     func overrideLayoutSubviews(handle: @escaping () -> Void) {
///         objc_setAssociatedObject(
///             self, &Layout.token,
///             handle as Layout.Handler,
///             objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC
///         )
///     }
/// 
///     func swizzledLayout() {
///         self.swizzledLayout()
///         (objc_getAssociatedObject(self, &Layout.token) as? Layout.Handler)?()
///     }
/// 
///     open override class func initialize() {
///         ///  Since `dispatch_once` is deprecated in Swift 3.0,
///         ///  this implementation is the alternative.
///         guard self === NSView.self else { return }
/// 
///         MyKit.swizzle(
///             type: NSView.self,
///             original: #selector(layout),
///             swizzled: #selector(swizzledLayout)
///         )
///     }
/// }
/// ```
///
/// - Parameter type:             class name
/// - Parameter originalSelector: name of original method
/// - Parameter swizzledSelector: name of replacement
public func swizzle(type: AnyClass, original originalSelector: Selector, swizzled swizzledSelector: Selector) {
    //  get method objects
    let originalMethod = class_getInstanceMethod(type, originalSelector)
    let swizzledMethod = class_getInstanceMethod(type, swizzledSelector)

    //  check whether original method has been swizzlled
    if class_addMethod(
            type, originalSelector,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
    ) {
        class_replaceMethod(
            type, swizzledSelector, originalMethod,
            method_getTypeEncoding(originalMethod)
        )
    } else {
        method_exchangeImplementations(
            originalMethod,
            swizzledMethod
        )
    }
}
