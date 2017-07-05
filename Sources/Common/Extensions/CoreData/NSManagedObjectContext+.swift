// 
// NSManagedObjectContext+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import CoreData

public extension NSManagedObjectContext {

    convenience init(appName name: String, type: String, at directory: FileManager.SearchPathDirectory = .documentDirectory) throws {
        let url = FileManager.default
            .urls(for: directory, in: .userDomainMask)
            .last?
            .appendingPathComponent("\(name)Data")

        let model = Bundle.main
            .url(forResource: name, withExtension: "momd")
            .flatMap(NSManagedObjectModel.init(contentsOf:))

        self.init(concurrencyType: .mainQueueConcurrencyType)
        self.persistentStoreCoordinator = try model
            .map(NSPersistentStoreCoordinator.init(managedObjectModel:))?
            .then { try $0.addPersistentStore(ofType: type, configurationName: nil, at: url, options: nil) }
        self.undoManager = UndoManager()
    }
}
