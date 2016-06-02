//
//  NSFetchRequest+.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/2/16.
//  
//

import CoreData

public extension NSFetchRequest {

    public convenience init<T: NSManagedObject>(type: T.Type) {
        self.init(entityName: type.entityName)
    }
}