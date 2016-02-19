//
//  CKRecord+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/14/16.
//  
//

public extension CKRecord {

    public convenience init<T: CloudRecord>(recordType: T.Type) {
        self.init(recordType: recordType == CloudUser.self ? CKRecordTypeUserRecord : String(recordType))
    }

    public func parseTo<T: CloudRecord>(type: T.Type) throws -> T {
        return try type.init(record: self)
    }
}