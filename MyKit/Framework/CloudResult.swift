//
//  CloudResult.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/17/16.
//  
//

public struct CloudResult<T: CloudRecord> {

    public var parsedObjects: [T] = []
    public var nextOperation: NSOperation?

    var fetchedRecords: [CKRecordID: CKRecord] = [:]

    init() {}
}