// 
// CKDatabase+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import CloudKit

public extension CKDatabase {

    func fetchCurrentUser() -> Promise<CKRecord> {
        return Promise { callback in
            let operation = CKFetchRecordsOperation.fetchCurrentUserRecordOperation()
            operation.perRecordCompletionBlock = { callback(Result($0, $2)) }
            self.add(operation)
        }
    }
}

public extension CKDatabase {

    func save(_ record: CKRecord) -> Promise<CKRecord> {
        return Promise { (callback: @escaping Result<CKRecord>.Callback) in
            let handler = Result.init >>> callback
            self.save(record, completionHandler: handler)
        }
    }

    func delete(withRecordID recordID: CKRecordID) -> Promise<CKRecordID> {
        return Promise { (callback: @escaping Result<CKRecordID>.Callback) in
            let handler = Result.init >>> callback
            self.delete(withRecordID: recordID, completionHandler: handler)
        }
    }

    func fetch(withRecordID recordID: CKRecordID) -> Promise<CKRecord> {
        return Promise { (callback: @escaping Result<CKRecord>.Callback) in
            let handler = Result.init >>> callback
            self.fetch(withRecordID: recordID, completionHandler: handler)
        }
    }

    func perform(_ query: CKQuery, inZoneWith zoneID: CKRecordZoneID? = nil) -> Promise<[CKRecord]> {
        return Promise { (callback: @escaping Result<[CKRecord]>.Callback) in
            let handler = Result.init >>> callback
            self.perform(query, inZoneWith: zoneID, completionHandler: handler)
        }
    }
}
