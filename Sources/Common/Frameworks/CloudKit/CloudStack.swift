/*
 * CloudStack.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CloudKit

public protocol CloudStack: class {

    var container: CKContainer { get }
}

public extension CloudStack {

    public var privateDatabase: CKDatabase {
        return container.privateCloudDatabase
    }

    public var publicDatabase: CKDatabase {
        return container.publicCloudDatabase
    }
}
