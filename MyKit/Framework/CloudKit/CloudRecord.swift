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

    func decodeFrom(record: CKRecord) {
        for key in record.allKeys() where self.respondsTo(key) {
            guard let value = record[key] else { continue }
            self.setValue(value, forKey: key)
        }
    }

    func encodeTo(record: CKRecord) {
        var count: UInt32 = 0
        let props = class_copyPropertyList(self.dynamicType, &count)

        (0..<Int(count)).flatMap {
            let string = property_getName(props[$0])
            return String(CString: string, encoding: NSUTF8StringEncoding)
        }.lazy.forEach {
            record[$0] = self.valueForKey($0) as? CKRecordValue
        }

        free(props)
    }
}

public class CloudObject: NSObject, CloudRecord {

    public private(set) var metadata: NSData?

    public init(record: CKRecord, cacheMetadata flag: Bool) throws {
        super.init()
        try reload(record, cacheMetadata: flag)
    }

    public override init() { super.init() }

    public func reload(record: CKRecord, cacheMetadata flag: Bool) throws {
        if record.recordType != String(self.dynamicType) {
            throw ParseError.MissedMatch
        }

        metadata = flag ? record.metadata : nil
        decodeFrom(record)
    }

    public func toRecord() -> CKRecord? {
        return metadata?.then {
            CKRecord(data: $0)
        }?.then {
            encodeTo($0)
        }
    }
}

public class CloudUser: NSObject, CloudRecord {

    public private(set) var metadata: NSData!

    public init(record: CKRecord) throws {
        super.init()
        try reload(record)
    }

    public func reload(record: CKRecord) throws {
        if record.recordType != CKRecordTypeUserRecord {
            throw ParseError.NotUserType
        }

        metadata = record.metadata
        decodeFrom(record)
    }

    public func toRecord() -> CKRecord {
        return metadata.then {
            CKRecord(data: $0)
        }!.then {
            encodeTo($0)
        }
    }
}