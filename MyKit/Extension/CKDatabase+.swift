//
//  CKDatabase+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/18/16.
//  
//

public extension CKDatabase {

    public func fetchCurrentUser() -> Promise<CKRecord> {
        return Promise({ callback in
            CKFetchRecordsOperation.fetchCurrentUserRecordOperation().then {
                $0.perRecordCompletionBlock = {
                    if let record = $0 {
                        callback(.Fullfill(record))
                    } else if let error = $2 {
                        callback(.Reject(error))
                    }
                }
            }
        } >>> self.addOperation)
    }
}

public extension CKDatabase {

    private func transform<T>(callback: Result<T>.Callback) -> (T?, NSError?) -> Void {
        return {
            if let result = $0 {
                callback(.Fullfill(result))
            } else if let error = $1 {
                callback(.Reject(error))
            }
        }
    }

    public func save(record: CKRecord) -> Promise<CKRecord> {
        return Promise(transform >>> { self.saveRecord(record, completionHandler: $0) })
    }

    public func delete(recordID: CKRecordID) -> Promise<CKRecordID> {
        return Promise(transform >>> { self.deleteRecordWithID(recordID, completionHandler: $0) })
    }

    public func fetch(recordID: CKRecordID) -> Promise<CKRecord> {
        return Promise(transform >>> { self.fetchRecordWithID(recordID, completionHandler: $0) })
    }

    public func perform(query: CKQuery, zone: CKRecordZoneID? = nil) -> Promise<[CKRecord]> {
        return Promise(transform >>> { self.performQuery(query, inZoneWithID: zone, completionHandler: $0) })
    }
}