//
//  Then.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/28/15.
//
//

public protocol Then: class {}

public extension Then {

    func then(@noescape f: Self throws -> Void) rethrows -> Self {
        try f(self)
        return self
    }

    func then<U>(@noescape f: Self throws -> U) rethrows -> U {
        return try f(self)
    }
}

extension NSObject: Then {}
extension Box: Then {}

#if os(iOS)
import UIKit

extension UIView: Then {}
#endif