//
//  NSObject+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/20/16.
//  
//

public extension NSObject {

    public func respondsTo(selector: String) -> Bool {
        return self.respondsToSelector(Selector(selector))
    }
}