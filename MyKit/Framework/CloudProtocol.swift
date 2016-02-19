//
//  CloudProtcol.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/12/16.
//
//

public protocol CloudResult {

    typealias Element

    var parsedObjects: [Element] { get set }
    var fetchedRecords: [CKRecordID: CKRecord] { get set }
    var queryCursors: [CKQueryCursor]? { get set }

    init()
}

extension CloudResult where Element: CloudRecord {

    public mutating func appendNewObject(type: Element.Type) -> Element {
        let record = CKRecord(recordType: Element.self).then {
            fetchedRecords[$0.recordID] = $0
        }

        return try! Element(record: record)
    }
}

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

public protocol CloudReference {

    var action: CKReferenceAction { get }
}

extension CloudReference where Self: CloudRecord {

    public var reference: CKReference {
        return id.targetOf(action)
    }
}