//
//  CKRecord+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/14/16.
//  
//

public extension CKRecord {

    public convenience init<T: CloudObject>(recordType: T.Type) {
        self.init(recordType: String(T.self))
    }

    public func extractTo<T: CloudObject>(type: T.Type) -> T? {
        return try? T(record: self)
    }
}