//
//  Fetching.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/28/15.
//
//

func fetchObjects(entity: String, context: NSManagedObjectContext, withPredicate format: String, _ args: [AnyObject]) throws -> [AnyObject] {
    let request = NSFetchRequest(entityName: entity)
    request.predicate = NSPredicate(format: format, argumentArray: args)

    return try context.executeFetchRequest(request)
}