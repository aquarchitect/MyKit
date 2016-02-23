//
//  CKDatabase+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/18/16.
//  
//

public extension CKDatabase {

    public func fetchUser<T: CloudUser>() -> Future<T> {
        return Future({ callback in
            CKFetchRecordsOperation.fetchCurrentUserRecordOperation().then {
                $0.perRecordCompletionBlock = {
                    if let record = $0, user = try? T(record: record) {
                        callback(.Success(user))
                    } else if let error = $2 {
                        callback(.Failure(error))
                    }
                }
            }
        } >>> self.addOperation)
    }

    public func save<T: CloudRecord>(object: T) -> Future<CKRecord> {
        return Future({ callback in
            self.saveRecord(object.recordToSave()) {
                if let record = $0 {
                    callback(.Success(record))
                } else if let error = $1 {
                    callback(.Failure(error))
                }
            }
        })
    }
}