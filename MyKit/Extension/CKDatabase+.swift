//
//  CKDatabase+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/18/16.
//  
//

public extension CKDatabase {

    public func fetchUser<T: CloudUser>(callback: Result<T>.Callback) -> Future<T> {
        return Future(operation: { callback in
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
}