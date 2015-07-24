//
//  NSCache+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension NSCache {

    final func fetchObjectForKey(key: AnyObject, withConstructor handle: Void -> AnyObject) -> AnyObject {
        var object: AnyObject? = self.objectForKey(key)
        if object == nil { object = handle(); self.setObject(object!, forKey: key) }

        return object!
    }
}