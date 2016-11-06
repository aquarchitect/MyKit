/*
 * CKContainer+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CloudKit

public extension CKContainer {

    func fetchUserRecordID() -> Promise<CKRecordID> {
        return Promise { callback in
            self.fetchUserRecordID {
                if let error = $1 {
                    callback(.reject(error))
                } else if let recordID = $0 {
                    callback(.fulfill(recordID))
                } else {
                    callback(.reject(PromiseError.empty))
                }
            }
        }
    }
}
