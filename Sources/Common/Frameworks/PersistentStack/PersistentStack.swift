/*
 * PersistentStack.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CoreData

fileprivate enum FileIOError: Error {

    case unableToOpen(file: String)
}

public protocol PersistentStack {

    var context: NSManagedObjectContext { get }
}

public extension PersistentStack {

    var coordinator: NSPersistentStoreCoordinator? {
        return context.persistentStoreCoordinator
    }
}

public  extension PersistentStack {

    static func context(forApp name: String, type: String, at directory: FileManager.SearchPathDirectory = .documentDirectory) throws -> NSManagedObjectContext {
        let url = FileManager.`default`
            .urls(for: directory, in: .userDomainMask)
            .last?
            .appendingPathComponent("\(name)Data")

        let model = Bundle.main
            .url(forResource: name, withExtension: "momd")
            .flatMap(NSManagedObjectModel.init(contentsOf:))


        guard let _url = url else { throw FileIOError.unableToOpen(file: "\(name)Data")}
        guard let _model = model else { throw FileIOError.unableToOpen(file: "\(name).momd") }

        let coordinator: NSPersistentStoreCoordinator = try NSPersistentStoreCoordinator(managedObjectModel: _model)
            .then { try $0.addPersistentStore(ofType: type, configurationName: nil, at: _url, options: nil) }

        return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType).then {
            $0.persistentStoreCoordinator = coordinator
            $0.undoManager = UndoManager()
        }
    }
}

