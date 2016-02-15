//
//  CKQuery+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/14/16.
//  
//

public extension CKQuery {

    public convenience init<T: CloudObject>(recordType: T.Type, predicate: NSPredicate) {
        self.init(recordType: String(T.self), predicate: predicate)
    }
}