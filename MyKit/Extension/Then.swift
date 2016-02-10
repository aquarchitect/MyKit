//
//  Then.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/28/15.
//
//

public protocol Then {}

extension Then {

    public func then(@noescape block: Self -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: Then {}