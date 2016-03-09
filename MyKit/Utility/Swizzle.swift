//
//  Swizzling.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

private enum Exception: ErrorType, CustomStringConvertible {

    case MethodNotFound(Selector)

    var description: String {
        switch self {

        case .MethodNotFound(let sel):
            return "\(sel) not found"
        }
    }
}

/**
Replaces original method.

- parameter type: Class name.
- parameter original: Name of original method.
- parameter swizzled: Name of replaced method.
*/
public func swizzle(type: AnyClass, original: Selector, swizzled: Selector) {
    // double check string typo
    [original, swizzled].forEach {
        guard !class_respondsToSelector(type, $0) else { return }
        fatalError(Exception.MethodNotFound($0).description)
    }

    // get objects of methods
    let originalMethod = class_getInstanceMethod(type, original)
    let swizzledMethod = class_getInstanceMethod(type, swizzled)

    // check whether original method has been replaced
    if class_addMethod(type, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) {
        class_replaceMethod(type, swizzled, originalMethod, method_getTypeEncoding(originalMethod))
    } else { method_exchangeImplementations(originalMethod, swizzledMethod) }
}