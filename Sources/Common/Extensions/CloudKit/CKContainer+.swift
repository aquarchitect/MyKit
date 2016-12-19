/*
 * CKContainer+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CloudKit

public extension CKContainer {

    func fetchUserRecordID() -> Observable<CKRecordID> {
        return Observable().then {
            self.fetchUserRecordID(completionHandler: $0.update)
        }
    }
}
