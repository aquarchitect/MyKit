//
//  NSManagedObjectContext+.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/18/16.
//
//

public extension NSManagedObjectContext {

    public func fetch<T: NSManagedObject>(predicate: NSPredicate, sortDescriptos: [NSSortDescriptor]) throws -> [T]? {
        return try NSFetchRequest(type: T.self).then {
                $0.predicate = predicate
                $0.sortDescriptors = sortDescriptos
            }.andThen {
                try self.executeFetchRequest($0) as? [T]
            }
    }
}