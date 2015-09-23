//
//  Fetching.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/28/15.
//
//

public func fetchObjects<T: NSManagedObject>(context: NSManagedObjectContext, withPredicate format: String, _ args: AnyObject...) throws -> [T]? {
    return try fetchObjects(context, withPredicate: NSPredicate(format: format, argumentArray: args))
}

public func fetchObjects<T: NSManagedObject>(context: NSManagedObjectContext, withPredicate predicate: NSPredicate) throws -> [T]? {
    let request = NSFetchRequest(entityName: T.entityName())
    request.predicate = predicate
    return try context.executeFetchRequest(request) as? [T]
}