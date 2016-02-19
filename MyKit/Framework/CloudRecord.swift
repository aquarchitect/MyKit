//
//  CloudRecord.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/17/16.
//  
//

private enum ParseError: ErrorType {

    case MissedMatch
    case NotUserType
}

// MARK: Record

public protocol CloudRecord: class {

    var id: CKRecordID { get }
    init(record: CKRecord) throws
    func archiveTo(record: CKRecord) throws
}

extension CloudRecord where Self: NSObject {

    private func parseFrom(record: CKRecord) {
        for key in record.allKeys() where self.respondsToSelector(Selector(key)) {
            guard let value = record[key] else { continue }
            self.setValue(value, forKey: key)
        }
    }

    private func commitTo(record: CKRecord) {
        for key in record.allKeys() where self.respondsToSelector(Selector(key)) {
            record[key] = self.valueForKey(key) as? CKRecordValue
        }
    }
}

// MARK: Object

public class CloudObject: NSObject, CloudRecord {

    public private(set) var id: CKRecordID

    public required init(record: CKRecord) throws {
        self.id = record.recordID
        super.init()

        if record.recordType != String(self.dynamicType) {
            throw ParseError.MissedMatch
        }

        parseFrom(record)
    }

    public func archiveTo(record: CKRecord) throws {
        if record.recordType != String(self.dynamicType) {
            throw ParseError.MissedMatch
        }

        commitTo(record)
    }
}

// MARK: User

public class CloudUser: NSObject, CloudRecord {

    public let id: CKRecordID

    public required init(record: CKRecord) throws {
        self.id = record.recordID
        super.init()

        if record.recordType != CKRecordTypeUserRecord {
            throw ParseError.NotUserType
        }
        
        parseFrom(record)
    }

    public func archiveTo(record: CKRecord) throws {
        if record.recordType != CKRecordTypeUserRecord {
            throw ParseError.NotUserType
        }

        commitTo(record)
    }
}