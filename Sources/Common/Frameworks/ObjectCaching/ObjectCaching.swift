/*
 * ObjectCaching.swift
 * MyKit
 *
 * Created by Hai Nguyen on 11/16/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

import Foundation

/**
 * Simple caching machenism on the instance level.
 * The idea is to incapsulate the gap between of controllers
 * and view model.
 */
public protocol ObjectCaching: class {

    associatedtype Key: AnyObject
    associatedtype Object: AnyObject

    static var storage: NSCache<Key, Object> { get }
    static var pendingOperationIDs: NSMutableSet { get }
}

public extension ObjectCaching where Self == Object {

    static func register(_ key: Key, with object: Self) {
        storage.setObject(object, forKey: key)
    }

    static func unregister(_ key: Key) {
        storage.removeObject(forKey: key)
    }

    static func registeredObject(forKey key: Key) -> Self? {
        return storage.object(forKey: key)
    }

    static func contains(registeredKey key: Key) -> Bool {
        return registeredObject(forKey: key) != nil
    }
}


public extension ObjectCaching where Self == Object {

    static func register(_ key: Key, with constructor: Promise<Self>) -> Promise<Void> {
        guard registeredObject(forKey: key) == nil else {
            return Promise.lift {}
        }

        guard !pendingOperationIDs.contains(key) else {
            return Promise<Void>.lift { throw PromiseError.empty }
        }

        pendingOperationIDs.add(key)

        return constructor.map {
            self.register(key, with: $0)

            objc_sync_enter(self.pendingOperationIDs)
            self.pendingOperationIDs.remove(key)
            objc_sync_exit(self.pendingOperationIDs)
        }
    }

    /**
     * Return a promise with constructor executing asynchronously.
     */
    static func register(_ key: Key, with constructor: @escaping () throws -> Self) -> Promise<Void> {
        return register(key, with: Promise.lift(constructor))
    }
}

#if os(iOS)
import UIKit
    
extension UIImage: ObjectCaching {

    public typealias Key = NSString

    public static var storage: NSCache<Key, UIImage> {
        struct Singleton { static let value = NSCache<NSString, UIImage>() }
        return Singleton.value
    }

    public static var pendingOperationIDs: Box<Set<Key>> {
        struct Singleton { static let value = Box(Set<Key>()) }
        return Singleton.value
    }
}
#elseif os(OSX)
import AppKit
/*
 * This solution is simply another alternative for the
 * native caching machenism. 
 *
 * Pros: generics and emiting of `NSCache`
 */
extension NSImage: ObjectCaching {

    public typealias Key = NSString

    public static var storage: NSCache<Key, NSImage> {
        struct Singleton { static let value = NSCache<NSString, NSImage>() }
        return Singleton.value
    }

    public static var pendingOperationIDs: NSMutableSet {
        struct Singleton { static let value = NSMutableSet() }
        return Singleton.value
    }
}
#endif
