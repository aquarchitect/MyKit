//
//  JSON.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/19/16.
//  
//

public protocol JSON {}

public extension JSON {

    public func toJSON() -> AnyObject? {
        var results: [String: AnyObject] = [:]

        for (key, value) in Mirror(reflecting: self).children {
            guard let _key = key else { continue }
            results[_key] = (value as? JSON)?.toJSON() ?? (value as? AnyObject)
        }

        return results
    }
}