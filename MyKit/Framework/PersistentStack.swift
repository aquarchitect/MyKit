//
//  PersistentStack.swift
//  MyKit
//
//  Created by Hai Nguyen on 9/24/15.
//
//

public class PersistentStack {

    public let context: NSManagedObjectContext
    public let coordinator: NSPersistentStoreCoordinator

    public init(appName: String) throws {
        var storeURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last
        storeURL = storeURL?.URLByAppendingPathComponent(appName + "Data.sqlite")

        let modelURL = NSBundle.mainBundle().URLForResource(appName, withExtension: "momd")
        let modelObject = NSManagedObjectModel(contentsOfURL: modelURL!)

        self.context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.coordinator = NSPersistentStoreCoordinator(managedObjectModel: modelObject!)
        try self.coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)

        self.context.persistentStoreCoordinator = coordinator
        self.context.undoManager = NSUndoManager()
    }
}