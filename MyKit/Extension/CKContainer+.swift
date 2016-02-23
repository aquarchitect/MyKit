//
//  CKContainer+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/20/16.
//  
//

public extension CKContainer {

    public func fetchUserID() -> Future<CKRecordID> {
        return Future { callback in
            self.fetchUserRecordIDWithCompletionHandler {
                if let recordID = $0 {
                    callback(.Success(recordID))
                } else if let error = $1 {
                    callback(.Failure(error))
                }
            }
        }
    }
}