/*
 * PersistentStack.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CoreData

public protocol PersistentStack {

    var context: NSManagedObjectContext { get }
}

public extension PersistentStack {

    var coordinator: NSPersistentStoreCoordinator? {
        return context.persistentStoreCoordinator
    }
}

public extension PersistentStack {

    static func context(forApp name: String, type: String, at directory: FileManager.SearchPathDirectory = .documentDirectory) throws -> NSManagedObjectContext {
        let url = FileManager.default
            .urls(for: directory, in: .userDomainMask)
            .last?
            .appendingPathComponent("\(name)Data")

        let model = Bundle.main
            .url(forResource: name, withExtension: "momd")
            .flatMap(NSManagedObjectModel.init(contentsOf:))

        return try NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType).then {
            $0.persistentStoreCoordinator = try model
                .map(NSPersistentStoreCoordinator.init(managedObjectModel:))?
                .then { try $0.addPersistentStore(ofType: type, configurationName: nil, at: url, options: nil) }
            $0.undoManager = UndoManager()
        }
    }
}
