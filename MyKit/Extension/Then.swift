//
//  Then.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/28/15.
//
//

public protocol Then {}

extension Then {

    public func then(@noescape f: Self -> Void) -> Self {
        f(self)
        return self
    }

    public func then<U>(@noescape f: Self -> U) -> U {
        return f(self)
    }
}

extension NSObject: Then {}