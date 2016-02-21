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

public protocol CloudRecord: class {}

private extension CloudRecord where Self: NSObject {

    func extractFrom(record: CKRecord) {
        for key in record.allKeys() where self.respondsTo(key) {
            guard let value = record[key] else { continue }
            self.setValue(value, forKey: key)
        }
    }

    func commitTo(record: CKRecord) {
        for key in record.allKeys() where self.respondsTo(key) {
            record[key] = self.valueForKey(key) as? CKRecordValue
        }
    }
}

public class CloudObject: NSObject, CloudRecord {

    public private(set) var metadata: NSData?

    public required init(record: CKRecord, cached: Bool) throws {
        super.init()

        guard record.recordType == String(self.dynamicType) else {
            throw ParseError.MissedMatch
        }

        metadata = cached ? record.archive() : nil
    }

    public func recordToSave() -> CKRecord {
        return (metadata?.record ?? CKRecord(recordType: self.dynamicType)).then { commitTo($0) }
    }
}

public class CloudUser: NSObject, CloudRecord {

    public private(set) var metadata: NSData!

    public required init(record: CKRecord) throws {
        super.init()

        guard record.recordType == CKRecordTypeUserRecord else {
            throw ParseError.NotUserType
        }

        metadata = record.archive()
    }

    public func recordToSave() -> CKRecord? {
        return metadata.record
    }
}

private extension NSData {

    var record: CKRecord? { return CKRecord(data: self) }
}