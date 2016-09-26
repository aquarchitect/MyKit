/*
 * CKDatabase+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CloudKit

public extension CKDatabase {

    func fetchCurrentUser() -> Promise<CKRecord> {
        return Promise({ callback in
            let operation = CKFetchRecordsOperation.fetchCurrentUserRecordOperation()
            operation.perRecordCompletionBlock = {
                if let error = $2 {
                    callback(.reject(error))
                } else if let record = $0 {
                    callback(.fullfill(record))
                } else {
                    callback(.reject(PromiseError.noData))
                }
            }
            return operation
        } >>> self.add)
    }
}

public extension CKDatabase {

    private func transform<T>(_ callback: @escaping Result<T>.Callback) -> (T?, Error?) -> Void {
        return {
            if let error = $1 {
                callback(.reject(error))
            } else if let result = $0 {
                callback(.fullfill(result))
            } else {
                callback(.reject(PromiseError.noData))
            }
        }
    }

    public func save(record: CKRecord) -> Promise<CKRecord> {
        return Promise(transform >>> { self.save(record, completionHandler: $0) })
    }

    public func delete(recordID: CKRecordID) -> Promise<CKRecordID> {
        return Promise(transform >>> { self.delete(withRecordID: recordID, completionHandler: $0) })
    }

    public func fetch(recordID: CKRecordID) -> Promise<CKRecord> {
        return Promise(transform >>> { self.fetch(withRecordID: recordID, completionHandler: $0) })
    }

    public func perform(query: CKQuery, zone: CKRecordZoneID? = nil) -> Promise<[CKRecord]> {
        return Promise(transform >>> { self.perform(query, inZoneWith: zone, completionHandler: $0) })
    }
}
