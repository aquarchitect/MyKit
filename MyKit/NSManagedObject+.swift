//
//  NSManagedObject+.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/20/15.
//
//

public extension NSManagedObject {

    public class func entityName() -> String {
        let fullName = NSStringFromClass(object_getClass(self))
        return String(fullName.characters.split(".").last!)
    }

    public convenience init(context: NSManagedObjectContext) {
        let name = self.dynamicType.entityName()
        let entity = NSEntityDescription.entityForName(name, inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}