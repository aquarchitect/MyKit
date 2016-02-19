//
//  CKQueryOperation+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/17/16.
//  
//

public extension CKQueryOperation {

    private convenience init<T: CloudResult where T.Element: CloudObject>(callback: Result<T>.Callback) {
        var result = T()
        self.init()
        self.recordFetchedBlock = {
            result.parsedObjects += [try? $0.parseTo(T.Element.self)].flatMap { $0 }
            result.fetchedRecords[$0.recordID] = $0
        }
        self.queryCompletionBlock = { cursor, error in
            if let _error = error {
                callback(.Failure(_error))
            } else {
                callback(.Success(result))
            }
        }
    }

    public convenience init<T: CloudResult where T.Element: CloudObject>(predicate: NSPredicate, callback: Result<T>.Callback) {
        self.init(callback: callback)
        self.query = CKQuery(recordType: T.Element.self, predicate: predicate)
    }

    public convenience init<T: CloudResult where T.Element: CloudObject>(cursor: CKQueryCursor, callback: Result<T>.Callback) {
        self.init(callback: callback)
        self.cursor = cursor
    }
}