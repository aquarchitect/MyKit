//
//  CKQueryOperation+.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/31/16.
//  
//

public extension CKQueryOperation {

    public convenience init<T: CloudObject>(predicate: NSPredicate, sorts: [NSSortDescriptor], completion: ([T], CKQueryCursor?, NSError?) -> Void) {
        var results = [T]()

        let query = CKQuery(recordType: String(T.self), predicate: predicate)
        query.sortDescriptors = sorts

        self.init(query: query)
        self.recordFetchedBlock = {
            if let object = T(record: $0) { results.append(object) }
        }
        self.queryCompletionBlock = { completion(results, $0, $1) }
    }
}