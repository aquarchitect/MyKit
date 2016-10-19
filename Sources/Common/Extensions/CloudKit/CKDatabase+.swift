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

        let constructOperation = { (callback: Result<CKRecord>.Callback) in
            let operation = CKFetchRecordsOperation.fetchCurrentUserRecordOperation()

            operation.perRecordCompletionBlock = {
                if let error = $2 {
                    callback(.reject(error))
                } else if let record = $0 {
                    callback(.fulfill(record))
                } else {
                    callback(.reject(PromiseError.empty))
                }
            }
            return operation
        }

#if swift(>=3.0)
        return Promise(constructOperation >>> self.add)
#else
        return Promise(constructOperation >>> self.addOperation)
#endif
    }
}

public extension CKDatabase {

#if swift(>=3.0)
    private func transform<T>(_ callback: @escaping Result<T>.Callback) -> (T?, Error?) -> Void {
        return {
            if let error = $1 {
                callback(.reject(error))
            } else if let result = $0 {
                callback(.fulfill(result))
            } else {
                callback(.reject(PromiseError.empty))
            }
        }
    }

    func save(record: CKRecord) -> Promise<CKRecord> {
        return Promise(transform >>> { self.save(record, completionHandler: $0) })
    }

    func delete(recordID: CKRecordID) -> Promise<CKRecordID> {
        return Promise(transform >>> { self.delete(withRecordID: recordID, completionHandler: $0) })
    }

    func fetch(recordID: CKRecordID) -> Promise<CKRecord> {
        return Promise(transform >>> { self.fetch(withRecordID: recordID, completionHandler: $0) })
    }

    func perform(query: CKQuery, zoneID: CKRecordZoneID? = nil) -> Promise<[CKRecord]> {
        return Promise(transform >>> { self.perform(query, inZoneWith: zoneID, completionHandler: $0) })
    }
#else
    private func transform<T>(callback: Result<T>.Callback) -> (T?, ErrorType?) -> Void {
        return {
            if let error = $1 {
                callback(.reject(error))
            } else if let result = $0 {
                callback(.fulfill(result))
            } else {
                callback(.reject(PromiseError.empty))
            }
        }
    }

    func saveRecord(record: CKRecord) -> Promise<CKRecord> {
        return Promise(transform >>> { self.saveRecord(record, completionHandler: $0) })
    }

    func deleteRecordID(recordID: CKRecordID) -> Promise<CKRecordID> {
        return Promise(transform >>> { self.deleteRecordWithID(recordID, completionHandler: $0) })
    }

    func fetchRecordID(recordID: CKRecordID) -> Promise<CKRecord> {
        return Promise(transform >>> { self.fetchRecordWithID(recordID, completionHandler: $0) })
    }

    func performQuery(query: CKQuery, inZoneWidthID zoneID: CKRecordZoneID? = nil) -> Promise<[CKRecord]> {
        return Promise(transform >>> { self.performQuery(query, inZoneWithID: zoneID, completionHandler: $0) })
    }
#endif
}
