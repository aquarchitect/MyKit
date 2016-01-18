//
//  Setup.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/28/15.
//
//

public protocol Setup {}

extension Setup {

    public func setup(@noescape block: Self -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: Setup {}