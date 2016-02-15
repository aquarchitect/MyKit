//
//  CloudManner.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/12/16.
//
//

// MARK: Model

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

// MARK: Reference

public protocol CloudReference {

    var action: CKReferenceAction { get }
}

extension CloudReference where Self: CloudObject {

    public var reference: CKReference {
        return recordID.referenceOf(action)
    }
}

// MARK: Record

public protocol CloudRecord: class {

    var recordID: CKRecordID { get }
    init(record: CKRecord) throws
}

extension CloudRecord where Self: NSObject {

    private func extract(record: CKRecord) {
        for key in record.allKeys() where self.respondsToSelector(Selector(key)) {
            guard let value = record[key] else { continue }
            self.setValue(value, forKey: key)
        }
    }

    public func saveTo(record: CKRecord) {
        assert(recordID != record.recordID, "Object does not match with record.")

        for key in record.allKeys() where self.respondsToSelector(Selector(key)) {
            record[key] = self.valueForKey(key) as? CKRecordValue
        }
    }
}

// MARK: Object

public class CloudObject: NSObject, CloudRecord {

    public private(set) var recordID: CKRecordID

    public required init(record: CKRecord) throws {
        self.recordID = record.recordID
        super.init()

        if record.recordType != String(self.dynamicType) {
            enum Error: ErrorType { case UnmatchedType }
            throw Error.UnmatchedType
        }

        extract(record)
    }

    public func transferToNewRecord() -> CKRecord {
        return CKRecord(recordType: String(self.dynamicType)).then {
            recordID = $0.recordID
            saveTo($0)
        }
    }
}

// MARK: User

public class CloudUser: NSObject, CloudRecord {

    public let recordID: CKRecordID

    public required init(record: CKRecord) throws {
        self.recordID = record.recordID
        super.init()

        if record.recordType != CKRecordTypeUserRecord {
            enum Error: ErrorType { case NotUserRecord }
            throw Error.NotUserRecord
        }

        extract(record)
    }
}

// MARK: Stack

public class CloudStack: NSObject {

    public let container: CKContainer

    public init(container: CKContainer = .defaultContainer()) {
        self.container = container
    }

    public func databaseFor(access: AccessControl) -> CKDatabase {
        switch access {

        case .Private: return container.privateCloudDatabase
        case .Public: return container.publicCloudDatabase
        }
    }

    public func execute(access: AccessControl, operation: CKDatabaseOperation) {
        databaseFor(access).addOperation(operation)
    }
}