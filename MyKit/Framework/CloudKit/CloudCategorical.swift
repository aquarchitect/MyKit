//
//  CloudCategorical.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/15/16.
//  
//

public protocol CloudCategorical {

    typealias Element
    var element: Element { get }
    init(record: CKRecord, cachedMetadata flag: Bool) throws
}

public extension CloudCategorical where Element: CloudObject {

    public typealias Callback = Result<([Self], CKQueryCursor?)>.Callback

    private static func fetch(cachedMetadata flag: Bool, callback: Callback) -> CKQueryOperation {
        var results: [Self] = []

        return CKQueryOperation().then {
            $0.recordFetchedBlock = {
                results += [try? Self(record: $0, cachedMetadata: flag)].flatMap { $0 }
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

    public static func fetch(cachedMetadata flag: Bool, predicate: NSPredicate) -> (Callback -> CKDatabaseOperation) {
        return { fetch(cachedMetadata: flag, callback: $0).then { $0.query = CKQuery(recordType: Element.self, predicate: predicate) }}
    }

    public static func fetch(cachedMetadata flag: Bool, cursor: CKQueryCursor) -> (Callback -> CKDatabaseOperation) {
        return { fetch(cachedMetadata: flag, callback: $0).then { $0.cursor = cursor }}
    }
}