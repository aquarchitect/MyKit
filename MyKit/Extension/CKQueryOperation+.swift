//
//  CKQueryOperation+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/17/16.
//  
//

public extension CKQueryOperation {

    internal convenience init<T: CloudObject>(_ cached: Bool, _ callback: Result<([T], CKQueryCursor)>.Callback) {
        var results: [T] = []

        self.init()
        self.recordFetchedBlock = {
            results += [try? T(record: $0, cached: cached)].flatMap { $0 }
        }
        self.queryCompletionBlock = {
            if let cursor = $0 {
                callback(.Success((results, cursor)))
            } else if let error = $1 {
                callback(.Failure(error))
            }
        }
    }
}