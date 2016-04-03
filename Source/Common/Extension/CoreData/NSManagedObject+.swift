//
//  NSManagedObject+.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/20/15.
//
//

public extension NSManagedObject {

    public static var entityName: String {
        return String(String(self.dynamicType).characters.split(".").last?.map { $0 } ?? [])
    }

    public convenience init?(context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entityFor(self.dynamicType, context: context) else { return nil }
        self.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}