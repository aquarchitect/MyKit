//
//  PersistentStack.swift
//  MyKit
//
//  Created by Hai Nguyen on 9/24/15.
//
//

public protocol PersistentStack {

    var context: NSManagedObjectContext { get }
}

public extension PersistentStack {

    public var coordinator: NSPersistentStoreCoordinator? {
        return context.persistentStoreCoordinator
    }

    public static func defaultContextFor(app name: String) throws -> NSManagedObjectContext {
        let url = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last?.then {
            $0.URLByAppendingPathComponent(name + "Data.sqlite")
        }

        let model = NSBundle.mainBundle().URLForResource(name, withExtension: "momd")?.then {
            NSManagedObjectModel(contentsOfURL: $0)
        }

        let coordinator = try NSPersistentStoreCoordinator(managedObjectModel: model!).then {
                try $0.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url!, options: nil)
            } as NSPersistentStoreCoordinator

        return NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType).then {
            $0.persistentStoreCoordinator = coordinator
            $0.undoManager = NSUndoManager()
        }
    }
}