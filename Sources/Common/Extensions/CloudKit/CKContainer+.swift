//
// CKContainer+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import CloudKit

public extension CKContainer {

#if true
    func fetchUserRecordID() -> Promise<CKRecordID> {
        return Promise { callback in
            self.fetchUserRecordID(completionHandler: Result.init >>> callback)
        }
    }
#else
    func fetchUserRecordID() -> Observable<CKRecordID> {
        return Observable().then {
            self.fetchUserRecordID(completionHandler: Result.init >>> $0.update)
        }
    }
#endif
}
