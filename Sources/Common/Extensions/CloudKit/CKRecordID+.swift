/*
 * CKRecordID+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CloudKit

extension CKRecordID {

    public func target(of action: CKReferenceAction) -> CKReference {
        return CKReference(recordID: self, action: action)
    }
}
