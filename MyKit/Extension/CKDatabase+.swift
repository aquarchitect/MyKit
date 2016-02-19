//
//  CKDatabase+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/18/16.
//  
//

public extension CKDatabase {

    public func fetch<T: CloudResult where T.Element: CloudObject>(predicate: NSPredicate) -> Future<T> {
        return Future(operation: { CKQueryOperation(predicate: predicate, callback: $0) } >>> self.addOperation)
    }

    public func fetch<T: CloudResult where T.Element: CloudObject>(cursor: CKQueryCursor) -> Future<T> {
        return Future(operation: { CKQueryOperation(cursor: cursor, callback: $0) } >>> self.addOperation)
    }

    public func fetchUser<T: CloudUser>(callback: Result<T>.Callback) -> Future<T> {
        let operation: Result<T>.Callback -> CKDatabaseOperation = { callback in
            return CKFetchRecordsOperation.fetchCurrentUserRecordOperation().then {
                $0.perRecordCompletionBlock = {
                    do {
                        if let user = try $0?.parseTo(T.self) {
                            callback(.Success(user))
                        } else if let error = $2 {
                            callback(.Failure(error))
                        }
                    } catch { callback(.Failure(error)) }
                }
            }
        }

        return Future(operation: operation >>> self.addOperation)
    }
}