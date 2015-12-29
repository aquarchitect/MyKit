//
//  Setup.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/28/15.
//
//

public protocol Setup {

    init()
}

extension Setup {

    public func setup(block: Self -> Void) -> Self {
        block(self)
        return self
    }

    public static func setup(block: Self -> Void) -> Self {
        let result = Self.init()
        block(result)
        return result
    }
}

extension NSObject: Setup {}