//
//  CKDatabase+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/18/16.
//  
//

public extension CKDatabase {

    private func handle(callback: Result<CKRecord>.Callback) -> ((CKRecord?, NSError?) -> Void) {
        return {
            if let record = $0 {
                callback(.Success(record))
            } else if let error = $1 {
                callback(.Failure(error))
            }
        }
    }

    public func fetchCurrentUser<T: CloudUser>() -> Future<T> {
        return Future({ callback in
            CKFetchRecordsOperation.fetchCurrentUserRecordOperation().then {
                $0.perRecordCompletionBlock = {
                    if let user = $0?.parseTo(T.self) {
                        callback(.Success(user))
                    } else if let error = $2 {
                        callback(.Failure(error))
                    }
                }
            }
        } >>> self.addOperation)
    }

    public func save(record: CKRecord) -> Future<CKRecord> {
        return Future(handle >>> { self.saveRecord(record, completionHandler: $0) })
    }

    public func fetch(recordID: CKRecordID) -> Future<CKRecord> {
        return Future(handle >>> { self.fetchRecordWithID(recordID, completionHandler: $0) })
    }
}

private extension CKRecord {

    func parseTo<T: CloudUser>(type: T.Type) -> T? {
        return T(record: self)
    }
}