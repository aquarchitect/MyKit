// 
// Caching.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import Foundation

/// A simple caching machenism works on object level.
public protocol Caching: class {

    associatedtype Key: AnyObject
    associatedtype Object: AnyObject

    static var storage: NSCache<Key, Object> { get }
    static var pendingOperationIDs: NSMutableSet { get }
}

public extension Caching {

    static func fetchObject(forKey key: Key, contructIfNeeded constructor: @autoclosure @escaping () throws -> Object) -> Promise<Object> {
        if let object = storage.object(forKey: key) {
            return Promise(object)
        } else if pendingOperationIDs.contains(key) {
            return Promise(Error.harmless)
        } else {
            pendingOperationIDs.add(key)

            return Promise { callback in
                do {
                    let object = try constructor()
                    self.storage.setObject(object, forKey: key)

                    objc_sync_enter(self.pendingOperationIDs)
                    self.pendingOperationIDs.remove(key)
                    objc_sync_exit(self.pendingOperationIDs)

                    callback(.fulfill(object))
                } catch {
                    callback(.reject(error))
                }
            }
        }
    }
}

#if os(iOS)
import UIKit

extension UIImage: Caching {

    public typealias Key = NSString

    public static var storage: NSCache<Key, UIImage> {
        struct Singleton {

            static let value = NSCache<NSString, UIImage>()
        }

        return Singleton.value
    }

    public static var pendingOperationIDs: NSMutableSet {
        struct Singleton {

            static let value = NSMutableSet()
        }

        return Singleton.value
    }
}
#elseif os(OSX)
import AppKit

// This solution is simply an alternative for the
// native `NSImage` caching machenism.
//
// Reference to `NSImage` documentation for more
// native caching machenism.
extension NSImage: Caching {

    public typealias Key = NSString

    public static var storage: NSCache<Key, NSImage> {
        struct Singleton {

            static let value = NSCache<NSString, NSImage>()
        }

        return Singleton.value
    }
    
    public static var pendingOperationIDs: NSMutableSet {
        struct Singleton {

            static let value = NSMutableSet()
        }

        return Singleton.value
    }
}
#endif
