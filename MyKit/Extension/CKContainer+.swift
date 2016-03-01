//
//  CKContainer+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/20/16.
//  
//

public extension CKContainer {

    public func fetchCurrentUserID() -> Promise<CKRecordID> {
        return Promise { callback in
            self.fetchUserRecordIDWithCompletionHandler {
                if let recordID = $0 {
                    callback(.Fullfill(recordID))
                } else if let error = $1 {
                    callback(.Reject(error))
                }
            }
        }
    }
}