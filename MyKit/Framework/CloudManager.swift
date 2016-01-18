//
//  CloudManager.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/12/16.
//
//

public protocol CloudRelation {

    var action: CKReferenceAction { get }
    var fetched: Bool { get }
}

public extension CloudRelation where Self: CloudObject {

    var reference: CKReference {
        return CKReference(record: record, action: action)
    }
}

public protocol CloudObject: Hashable {

    static var Key: String { get }
    var record: CKRecord { get }
    var access: CloudManager.Access { get }
}

public extension CloudObject {

    public var hashValue: Int {
        return record.recordID.hashValue
    }

    public func checkType() -> Bool {
        return record.recordType == self.dynamicType.Key
    }
}

public func == <T: CloudObject>(lhs: T, rhs: T) -> Bool {
    return lhs.record == rhs.record
}

public class CloudManager {

    public static let ErrorNotification = "CloudErrorNotification"

    public enum Access { case Private, Public }

    public let container: CKContainer
    public var userRecordID: CKRecordID?

    public init(container: CKContainer = CKContainer.defaultContainer()) {
        self.container = container
    }

    public func databaseWithAccess(access: Access) -> CKDatabase {
        switch access {

        case .Private: return container.privateCloudDatabase
        case .Public: return container.publicCloudDatabase
        }
    }

    public func saveObject<T: CloudObject>(object: T) {
        let database = databaseWithAccess(object.access)
        database.saveRecord(object.record, completionHandler: { _, _ in })
    }

    public func deleteObject<T: CloudObject>(object: T) {
        let database = databaseWithAccess(object.access)
        database.deleteRecordWithID(object.record.recordID, completionHandler: { _, _ in })
    }

    public func modifyRecordsWithAccess(access: Access, records: (save: [CKRecord], delete: [CKRecord]), completion: (Void -> Void)? = nil) {
        let operation = CKModifyRecordsOperation()
        operation.recordIDsToDelete = records.delete.map { $0.recordID }
        operation.recordsToSave = records.save
        operation.modifyRecordsCompletionBlock = { _, _, error in
            if let code = error as? CKErrorCode {
                self.dynamicType.postErrorNotification(code)
            } else { completion?() }
        }
        databaseWithAccess(access).addOperation(operation)
    }

    public static func postErrorNotification(error: CKErrorCode) {
        print(error.rawValue)
        NSNotificationCenter.defaultCenter().postNotificationName(ErrorNotification, object: Box(error))
    }
}