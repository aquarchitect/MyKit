//
//  NSFetchRequest+.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/2/16.
//  
//

public extension NSFetchRequest {

    public convenience init<T: NSManagedObject>(type: T.Type) {
        self.init(entityName: type.entityName)
    }
}