/*
 * Caching.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import Foundation

/**
 * Simple caching machenism on the instance level.
 * The idea is to incapsulate the gap between of controllers
 * and view model.
 */
public protocol Caching: class {

    associatedtype Key: AnyObject
    associatedtype Object: AnyObject

    static var storage: NSCache<Key, Object> { get }
    static var pendingOperationIDs: NSMutableSet { get }
}

public extension Caching {

    /**
     * The constructor can be either an async or sync task.
     */
    static func fetchObject(for key: Key, with constructor: Promise<Object>) -> Observable<Object> {
        if let object = storage.object(forKey: key) {
            return .lift { object }
        } else if pendingOperationIDs.contains(key) {
            return .init()
        } else {
            pendingOperationIDs.add(key)

            return constructor().onNext {
                self.storage.setObject($0, forKey: key)

                objc_sync_enter(self.pendingOperationIDs)
                self.pendingOperationIDs.remove(key)
                objc_sync_exit(self.pendingOperationIDs)
            }
        }
    }
}

#if os(iOS)
import UIKit

extension UIImage: Caching {

    public typealias Key = NSString

    public static var storage: NSCache<Key, UIImage> {
        struct Singleton { static let value = NSCache<NSString, UIImage>() }
        return Singleton.value
    }

    public static var pendingOperationIDs: NSMutableSet {
        struct Singleton { static let value = NSMutableSet() }
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
extension NSImage: Caching {

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
