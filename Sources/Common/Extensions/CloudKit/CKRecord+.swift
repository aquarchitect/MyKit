/*
 * CKRecord+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CloudKit

public extension CKRecord {

    var metadata: NSData {
        let data = NSMutableData()

        NSKeyedArchiver(forWritingWith: data).then {
            $0.requiresSecureCoding = true
            self.encodeSystemFields(with: $0)
            $0.finishEncoding()
        }

        return data
    }

    convenience init?(metadata: Data) {
        let coder = NSKeyedUnarchiver(forReadingWith: metadata)
        self.init(coder: coder)
        coder.finishDecoding()
    }
}
