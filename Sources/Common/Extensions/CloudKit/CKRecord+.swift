/*
 * CKRecord+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CloudKit

public extension CKRecord {

#if swift(>=3.0)
    var metadata: Data {
        let data = NSMutableData()

        NSKeyedArchiver(forWritingWith: data).then {
            $0.requiresSecureCoding = true
            self.encodeSystemFields(with: $0)
            $0.finishEncoding()
        }

        return data as Data
    }

    convenience init?(metadata: Data) {
        let coder = NSKeyedUnarchiver(forReadingWith: metadata)
        self.init(coder: coder)
        coder.finishDecoding()
    }
#else
    var metadata: NSData {
        let data = NSMutableData()

        NSKeyedArchiver(forWritingWithMutableData: data).then {
            $0.requiresSecureCoding = true
            self.encodeSystemFieldsWithCoder($0)
            $0.finishEncoding()
        }

        return data
    }

    convenience init?(metadata: NSData) {
        let coder = NSKeyedUnarchiver(forReadingWithData: metadata)
        self.init(coder: coder)
        coder.finishDecoding()
    }
#endif
}
