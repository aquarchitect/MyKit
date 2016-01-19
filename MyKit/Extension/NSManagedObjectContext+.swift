//
//  NSManagedObjectContext+.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/18/16.
//
//

public extension NSManagedObjectContext {

    public func fetchObjects<T: NSManagedObject>(predicate: NSPredicate, sortDescriptos: [NSSortDescriptor]) throws -> [T]? {
        let request = NSFetchRequest(entityName: T.entityName())
        request.predicate = predicate
        request.sortDescriptors = sortDescriptos
        return try self.executeFetchRequest(request) as? [T]
    }
}