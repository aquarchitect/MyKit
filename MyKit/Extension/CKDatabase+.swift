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

    private typealias NetworkCallCompletionHandler = (CKRecord?, NSError?) -> Void

    private func redirect(callback: Result<CKRecord>.Callback) -> NetworkCallCompletionHandler {
        return {
            if let record = $0 {
                callback(.Fullfill(record))
            } else if let error = $1 {
                callback(.Reject(error))
            }
        }
    }

    public func save(record: CKRecord) -> Promise<CKRecord> {
        return Promise(redirect >>> { self.saveRecord(record, completionHandler: $0) })
    }

    public func fetch(recordID: CKRecordID) -> Promise<CKRecord> {
        return Promise(redirect >>> { self.fetchRecordWithID(recordID, completionHandler: $0) })
    }
}