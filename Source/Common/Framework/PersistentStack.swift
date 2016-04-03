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

    public static func contextFor(app name: String, withType type: String = NSSQLiteStoreType) throws -> NSManagedObjectContext {
        let url = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last?.then {
            $0.URLByAppendingPathComponent("\(name)Data.sqlite")
        }

        let model = NSBundle.mainBundle().URLForResource(name, withExtension: "momd")?
            .andThen { NSManagedObjectModel(contentsOfURL: $0) }

        guard let _url = url else { throw CommonError.FailedToLocate(file: "\(name)Data.sqlite")}
        guard let _model = model else { throw CommonError.FailedToLocate(file: "\(name).momd") }

        let coordinator = try NSPersistentStoreCoordinator(managedObjectModel: _model).then {
                try $0.addPersistentStoreWithType(type, configuration: nil, URL: _url, options: nil)
            } as NSPersistentStoreCoordinator

        return NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType).then {
            $0.persistentStoreCoordinator = coordinator
            $0.undoManager = NSUndoManager()
        }
    }
}