//
//  ActionWrapper.swift
//  MyKit
//
//  Created by Hai Nguyen on 5/17/16.
//  
//

final class ActionWrapper<T>: NSObject {

    let f: T -> Void

    init(f: T -> Void) {
        self.f = f
    }

    override func copy() -> AnyObject {
        return self
    }
}