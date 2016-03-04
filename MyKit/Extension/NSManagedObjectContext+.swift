//
//  NSManagedObjectContext+.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/18/16.
//
//

public extension NSManagedObjectContext {

    public func fetchObjects<T: NSManagedObject>(predicate: NSPredicate, sortDescriptos: [NSSortDescriptor]) throws -> [T]? {
        return try NSFetchRequest(entityName: T.entityName()).then {
            $0.predicate = predicate
            $0.sortDescriptors = sortDescriptos
        }.then {
            try self.executeRequest($0) as? [T]
        }
    }
}