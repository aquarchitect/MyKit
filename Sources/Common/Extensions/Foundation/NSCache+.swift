//
//  NSCache+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

import Foundation

public extension NSCache {

    final public func fetchObjectFor<T>(key: AnyObject, @noescape f: Void -> T) -> T {
        return (self.objectForKey(key) as? Box<T> ??
                Box(f()).then { self.setObject($0, forKey: key) }).value
    }
}