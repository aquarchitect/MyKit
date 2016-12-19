/*
 * CKDatabase+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CloudKit

public extension CKDatabase {

    func fetchCurrentUser() -> Observable<CKRecord> {
        let observable = Observable<CKRecord>()

        let operation = CKFetchRecordsOperation.fetchCurrentUserRecordOperation()
        operation.perRecordCompletionBlock = { observable.update($0, $2) }
        self.add(operation)

        return observable
    }
}

public extension CKDatabase {

    func save(_ record: CKRecord) -> Observable<CKRecord> {
        return Observable().then {
            self.save(record, completionHandler: $0.update)
        }
    }

    func delete(withRecordID recordID: CKRecordID) -> Observable<CKRecordID> {
        return Observable().then {
            self.delete(withRecordID: recordID, completionHandler: $0.update)
        }
    }

    func fetch(withRecordID recordID: CKRecordID) -> Observable<CKRecord> {
        return Observable().then {
            self.fetch(withRecordID: recordID, completionHandler: $0.update)
        }
    }

    func perform(_ query: CKQuery, inZoneWith zoneID: CKRecordZoneID? = nil) -> Observable<[CKRecord]> {
        return Observable().then {
            self.perform(query, inZoneWith: zoneID, completionHandler: $0.update)
        }
    }
}
