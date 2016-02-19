//
//  CloudResult.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/17/16.
//  
//

public struct CloudResult<T: CloudObject>: CloudModel {

    public typealias Element = T

    public var parsedObjects: [Element] = []
    public var nextOperation: CKDatabaseOperation?

    public var fetchedRecords: [CKRecordID: CKRecord] = [:]

    init() {}
}