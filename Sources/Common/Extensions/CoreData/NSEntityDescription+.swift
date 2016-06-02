//
//  NSEntityDescription+.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/31/15.
//
//

import CoreData

public extension NSEntityDescription {

    public convenience init<T: NSManagedObject>(type: T.Type) {
        let name = type.entityName

        self.init()
        self.name = name
        self.managedObjectClassName = name
    }

    public static func entityFor<T: NSManagedObject>(type: T.Type, context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(type.entityName, inManagedObjectContext: context)
    }
}