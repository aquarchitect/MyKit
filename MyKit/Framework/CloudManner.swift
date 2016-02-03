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

public class CloudObject {

    public static var Key: String {
        return String(self.dynamicType)
    }

    public let record: CKRecord

    public required init?(record: CKRecord) {
        self.record = record

        if record.recordType != CloudObject.Key {
            return nil
        }
    }

    public init() {
        self.record = CKRecord(recordType: CloudObject.Key)
    }
}

extension CloudObject: Setup {}

public class CloudStack {

    public typealias UserRecordIDHandler = (CKRecordID?, NSError?) -> Void
    public enum Access { case Private, Public }

    private var userRecordID: CKRecordID?
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
    public func fetchUserRecordID(completion: UserRecordIDHandler) {
        if let recordID = self.userRecordID {
            completion(recordID, nil)
        } else {
            container.fetchUserRecordIDWithCompletionHandler { [weak self] in
                self?.userRecordID = $0
                completion($0, $1)
            }
        }
    }

    public func execute(access: Access, operation: CKDatabaseOperation) {
        databaseFor(access).addOperation(operation)
    }
}