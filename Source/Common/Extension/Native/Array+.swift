//
//  Array+.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/30/16.
//  
//

public extension Array where Element: Hashable {

    public func distint() -> Array<Element> {
        return Array(Set(self))
    }
}