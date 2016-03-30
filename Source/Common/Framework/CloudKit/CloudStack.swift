//
//  CloudStack.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/12/16.
//
//

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