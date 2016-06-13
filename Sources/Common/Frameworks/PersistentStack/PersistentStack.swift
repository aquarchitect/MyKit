/*
 * PersistentStack.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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