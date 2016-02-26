//
//  CloudQuery.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/25/16.
//  
//

public protocol CloudQuery: class {

    init?(record: CKRecord, cached: Bool)
}

extension CloudQuery {

    public typealias Callback = Result<([Self], CKQueryCursor?)>.Callback

    private static func fetchData(cached: Bool, _ callback: Callback) -> CKQueryOperation {
        var results = [Self]()
        return CKQueryOperation().then {
            $0.recordFetchedBlock = {
                results += [Self.init(record: $0, cached: cached)].flatMap { $0 }
            }
            $0.queryCompletionBlock = {
                if let error = $1 {
                    callback(.Reject(error))
                } else {
                    callback(.Fullfill((results, $0)))
                }
            }
        }
    }

    public static func fetchData(predicate predicate: NSPredicate, cached: Bool) -> (Callback -> CKQueryOperation) {
        return { fetchData(cached, $0).then { $0.query = CKQuery(recordType: String(self), predicate: predicate) }}
    }

    public static func fetchData(cursor cursor: CKQueryCursor, cached: Bool) -> (Callback -> CKQueryOperation) {
        return { fetchData(cached, $0).then { $0.cursor = cursor }}
    }
}