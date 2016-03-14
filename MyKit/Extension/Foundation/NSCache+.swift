//
//  NSCache+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

public extension NSCache {

    final func fetchObjectForKey<T>(key: AnyObject, @noescape withConstructor constructor: Void -> T) -> T {
        if let object = self.objectForKey(key) as? T { return object }
        return Box(constructor()).then { self.setObject($0, forKey: key) }.value
    }
}