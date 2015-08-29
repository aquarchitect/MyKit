//
//  NSManagedObjectContext+.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/28/15.
//
//

import CoreData

public extension NSManagedObjectContext {

    public func fetchObjectWithEntity(entity: String, withPredicate format: String, _ args: AnyObject...) throws -> [AnyObject] {
        return try fetchObjects(entity, context: self, withPredicate: format, args)
    }
}