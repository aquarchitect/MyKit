//
//  CloudManner.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/12/16.
//
//

public protocol CloudModel: class {

    var fetchedRecords: [CKRecordID: CKRecord] { get set }
}

extension CloudModel {

    public func appendNewObject<T: CloudObject>(type: T.Type) -> T {
        let record = CKRecord(recordType: T.self).then {
            fetchedRecords[$0.recordID] = $0
        }

        return try! T(record: record)
    }
}

public protocol CloudReference {

    var action: CKReferenceAction { get }
}

extension CloudReference where Self: CloudRecord {

    public var reference: CKReference {
        return recordID.referenceOf(action)
    }
}