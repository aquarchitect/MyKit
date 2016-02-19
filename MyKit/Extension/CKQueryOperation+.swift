//
//  CKQueryOperation+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/17/16.
//  
//

public extension CKQueryOperation {

    public var predicate: NSPredicate? {
        get { return self.query?.predicate }
        set {
            guard let value = newValue, type = self.query?.recordType
                else { return self.cancel() }
            self.query = CKQuery(recordType: type, predicate: value)
        }
    }

    public convenience init<T: CloudObject>(callback: Result<CloudResult<T>> -> Void) {
        let predicate = NSPredicate(value: true)
        var result = CloudResult<T>()

        self.init()
        self.query = CKQuery(recordType: T.self, predicate: predicate)
        self.recordFetchedBlock = {
            result.parsedObjects += [$0.extractTo(T.self)].flatMap { $0 }
            result.fetchedRecords[$0.recordID] = $0
        }
        self.queryCompletionBlock = { cursor, error in
            if let _cursor = cursor {
                CKQueryOperation(callback: callback).then {
                    $0.cursor = _cursor
                    result.nextOperation = $0
                }
                callback(.Success(result))
            } else if let _error = error {
                callback(.Failure(_error))
            }
        }
    }
}