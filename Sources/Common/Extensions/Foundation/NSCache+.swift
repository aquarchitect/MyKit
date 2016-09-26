/*
 * NSCache+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

public extension NSCache {

    // FIXME: bug

    func fetchObject(forKey key: KeyType, construct: () -> ObjectType) -> ObjectType {
        return (self.object(forKey: key) as? Box<ObjectType>)!.value
    }
}
