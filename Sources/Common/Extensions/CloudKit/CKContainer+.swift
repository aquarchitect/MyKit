//
// CKContainer+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import CloudKit

public extension CKContainer {

    func fetchUserRecordID() -> Promise<CKRecordID> {
        return Promise { (callback: @escaping Result<CKRecordID>.Callback) in
            let handler = Result.init >>> callback
            self.fetchUserRecordID(completionHandler: handler)
        }
    }
}
