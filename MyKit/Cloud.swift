//
//  Cloud.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/6/16.
//
//

public let CloudErrorNotification = "CloudErrorNotificaiton"

public protocol Cloud: Hashable {

    static var Key: String { get }
    var record: CKRecord { get }
    var action: CKReferenceAction { get }
}

public extension Cloud {

    public var hashValue: Int {
        return record.recordID.hashValue
    }

    public var reference: CKReference {
        return CKReference(record: record, action: action)
    }
}

public func == <T: Cloud>(lhs: T, rhs: T) -> Bool {
    return lhs.record == rhs.record
}