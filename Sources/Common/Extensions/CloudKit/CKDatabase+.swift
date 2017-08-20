// 
// CKDatabase+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import CloudKit

public extension CKDatabase {

#if true
    func fetchCurrentUser() -> Promise<CKRecord> {
        return Promise { callback in
            let operation = CKFetchRecordsOperation.fetchCurrentUserRecordOperation()
            operation.perRecordCompletionBlock = {
                callback(Result($0, $2))
            }
            self.add(operation)
        }
    }
#else
    func fetchCurrentUser() -> Observable<CKRecord> {
        let observable = Observable<CKRecord>()

        let operation = CKFetchRecordsOperation.fetchCurrentUserRecordOperation()
        operation.perRecordCompletionBlock = { (Result.init >>> observable.update)(($0, $2)) }
        self.add(operation)

        return observable
    }
#endif
}

public extension CKDatabase {

#if true
    func save(_ record: CKRecord) -> Promise<CKRecord> {
        return Promise { callback in
            self.save(record, completionHandler: Result.init >>> callback)
        }
    }
#else
    func save(_ record: CKRecord) -> Observable<CKRecord> {
        return Observable().then {
            self.save(record, completionHandler: Result.init >>> $0.update)
        }
    }
#endif

#if true
    func delete(withRecordID recordID: CKRecordID) -> Promise<CKRecordID> {
        return Promise { callback in
            self.delete(withRecordID: recordID, completionHandler: Result.init >>> callback)
        }
    }
#else
    func delete(withRecordID recordID: CKRecordID) -> Observable<CKRecordID> {
        return Observable().then {
            self.delete(withRecordID: recordID, completionHandler: Result.init >>> $0.update)
        }
    }
#endif

#if true
    func fetch(withRecordID recordID: CKRecordID) -> Promise<CKRecord> {
        return Promise { callback in
            self.fetch(withRecordID: recordID, completionHandler: Result.init >>> callback)
        }
    }
#else
    func fetch(withRecordID recordID: CKRecordID) -> Observable<CKRecord> {
        return Observable().then {
            self.fetch(withRecordID: recordID, completionHandler: Result.init >>> $0.update)
        }
    }
#endif

#if true
    func perform(_ query: CKQuery, inZoneWith zoneID: CKRecordZoneID? = nil) -> Promise<[CKRecord]> {
        return Promise { callback in
            self.perform(query, inZoneWith: zoneID, completionHandler: Result.init >>> callback)
        }
    }
#else
    func perform(_ query: CKQuery, inZoneWith zoneID: CKRecordZoneID? = nil) -> Observable<[CKRecord]> {
        return Observable().then {
            self.perform(query, inZoneWith: zoneID, completionHandler: Result.init >>> $0.update)
        }
    }
#endif
}
