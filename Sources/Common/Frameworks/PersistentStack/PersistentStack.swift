//
//  PersistentStack.swift
//  MyKit
//
//  Created by Hai Nguyen on 9/24/15.
//
//

import CoreData

public protocol PersistentStack {

    var context: NSManagedObjectContext { get }
}

public extension PersistentStack {

    public var coordinator: NSPersistentStoreCoordinator? {
        return context.persistentStoreCoordinator
    }

    // TODO: different set up for core data on OS X - store inside a directionry in Application Support
    public static func contextFor(app name: String, withType type: String) throws -> NSManagedObjectContext {
        let url = NSFileManager.defaultManager()
            .URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last?
            .then { $0.URLByAppendingPathComponent("\(name)Data") }

        let model = NSBundle.mainBundle()
            .URLForResource(name, withExtension: "momd")?
            .then { NSManagedObjectModel(contentsOfURL: $0) }

        guard let _url = url else { throw Error.FailedToLocate(file: "\(name)Data")}
        guard let _model = model else { throw Error.FailedToLocate(file: "\(name).momd") }

        let coordinator: NSPersistentStoreCoordinator = try NSPersistentStoreCoordinator(managedObjectModel: _model)
            .then { try $0.addPersistentStoreWithType(type, configuration: nil, URL: _url, options: nil) }

        return NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType).then {
                $0.persistentStoreCoordinator = coordinator
                $0.undoManager = NSUndoManager()
            }
    }
}