//
//  CloudRecord.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/17/16.
//  
//

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