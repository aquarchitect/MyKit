//
//  CKDatabase+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/18/16.
//  
//

public extension CKDatabase {

    public func fetch<T: CloudObject>(predicate: NSPredicate, keys: [String]? = nil, cached: Bool = false) -> Future<([T], CKQueryCursor)> {
        return Future(operation: {
            CKQueryOperation(cached, $0).then {
                $0.query = CKQuery(recordType: T.self, predicate: predicate)
                $0.desiredKeys = keys
            }
        } >>> self.addOperation)
    }

    public func fetch<T: CloudObject>(cursor: CKQueryCursor, keys: [String]? = nil, cached: Bool = false) -> Future<([T], CKQueryCursor)> {
        return Future(operation: {
            CKQueryOperation(cached, $0).then {
                $0.cursor = cursor
                $0.desiredKeys = keys
            }
        } >>> self.addOperation)
    }

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