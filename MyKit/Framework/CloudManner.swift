//
//  CloudManner.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/12/16.
//
//

public protocol CloudController: class {

    var cloudStack: CloudStack { get }
    func fetchData()
}

public protocol CloudReference {

    var action: CKReferenceAction { get }
}

extension CloudReference where Self: CloudObject {

    public var reference: CKReference {
        return recordID.referenceWithAction(action)
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

    public typealias UserRecordHandler = (CKReference?, NSError?) -> Void
    public enum Access { case Private, Public }

    private var userRecordReference: CKReference?
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
    public func fetchUserRecordReference(completion: UserRecordHandler) {
        if let reference = self.userRecordReference {
            completion(reference, nil)
        } else {
            container.fetchUserRecordIDWithCompletionHandler { [weak self] in
                if let error = $1 { completion(nil, error); return }
                self?.userRecordReference = $0?.referenceWithAction(.None).then { completion($0, nil) }
            }
        }
    }

    public func execute(access: Access, operation: CKDatabaseOperation) {
        databaseFor(access).addOperation(operation)
    }
}