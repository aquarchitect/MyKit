//
//  NSManagedObject+.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/20/15.
//
//

public extension NSManagedObject {

    public convenience init(name: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(name, inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}