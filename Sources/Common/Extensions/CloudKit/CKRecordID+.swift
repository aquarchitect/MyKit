//
//  CKRecordID+.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/31/16.
//  
//

import CloudKit

extension CKRecordID {

    public func targetOf(action: CKReferenceAction) -> CKReference {
        return CKReference(recordID: self, action: action)
    }
}