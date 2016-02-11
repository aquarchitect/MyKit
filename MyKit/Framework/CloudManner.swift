//
//  CloudManner.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/12/16.
//
//

public protocol CloudReference {

    var action: CKReferenceAction { get }
}

extension CloudReference where Self: CloudObject {

    public var reference: CKReference {
        return recordID.referenceOf(action)
    }
}

public class CloudObject: NSObject {

    public var recordID: CKRecordID

    public required init(record: CKRecord) throws {
        self.recordID = record.recordID
        super.init()

        if record.recordType != String(self.dynamicType) {
            enum Error: ErrorType { case UnmatchedType }
            throw Error.UnmatchedType
        }
    }
}

public class CloudStack {

    @objc public enum Access: Int { case Private, Public }

    public private(set) var userRecordReference: CKReference?
    public let container: CKContainer

    public init(container: CKContainer = .defaultContainer()) {
        self.container = container
    }

    public func databaseFor(access: Access) -> CKDatabase {
        switch access {

        case .Private: return container.privateCloudDatabase
        case .Public: return container.publicCloudDatabase
        }
    }

    /// User record ID will be cached after the initial fetching
    public func fetchUserRecordReference(completion: (CKReference?, NSError?) -> Void) {
        if let reference = self.userRecordReference { completion(reference, nil); return }

        container.fetchUserRecordIDWithCompletionHandler { [weak self] in
            if let error = $1 { completion(nil, error); return }
            self?.userRecordReference = $0?.referenceOf(.None).then { completion($0, nil) }
        }
    }

    public func execute(access: Access, operation: CKDatabaseOperation) {
        databaseFor(access).addOperation(operation)
    }
}