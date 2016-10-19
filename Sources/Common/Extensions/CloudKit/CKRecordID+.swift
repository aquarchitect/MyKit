/*
 * CKRecordID+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CloudKit

public extension CKRecordID {

#if swift(>=3.0)
    func target(of action: CKReferenceAction) -> CKReference {
        return CKReference(recordID: self, action: action)
    }
#else
    func targetOfAction(action: CKReferenceAction) -> CKReference {
        return CKReference(recordID: self, action: action)
    }
#endif
}
