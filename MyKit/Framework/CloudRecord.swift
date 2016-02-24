//
//  CloudRecord.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/17/16.
//  
//

public protocol CloudRecord: class {}

private extension CloudRecord where Self: NSObject {

    func decodeFrom(record: CKRecord) {
        for key in record.allKeys() where self.respondsTo(key) {
            guard let value = record[key] else { continue }
            self.setValue(value, forKey: key.camelcaseString)
        }
    }

    func encodeTo(record: CKRecord) {
        for key in record.allKeys() where self.respondsTo(key) {
            record[key] = self.valueForKey(key.camelcaseString) as? CKRecordValue
        }
    }
}

public class CloudObject: NSObject, CloudRecord {

    public private(set) var metadata: NSData?

    public init?(record: CKRecord, cached: Bool) {
        self.metadata = cached ? record.archive() : nil
        super.init()

        if record.recordType == String(self.dynamicType) { return nil }
        decodeFrom(record)
    }

    public override init() {
        super.init()
    }

    public func toRecord() -> CKRecord {
        return (metadata?.record ?? CKRecord(recordType: self.dynamicType)).then { encodeTo($0) }
    }
}

public class CloudUser: NSObject, CloudRecord {

    public let metadata: NSData

    public required init?(record: CKRecord) {
        self.metadata = record.archive()
        super.init()

        if record.recordType == CKRecordTypeUserRecord { return nil }
        decodeFrom(record)
    }

    public func toRecord() -> CKRecord? {
        return metadata.record
    }
}

private extension NSData {

    var record: CKRecord? {
        return CKRecord(data: self)
    }
}