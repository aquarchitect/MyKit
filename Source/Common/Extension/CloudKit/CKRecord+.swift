//
//  CKRecord+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/14/16.
//  
//

public extension CKRecord {

    public convenience init<T: CloudObject>(recordType: T.Type) {
        self.init(recordType: String(recordType))
    }

    public var metadata: NSData {
        return NSMutableData().then {
            NSKeyedArchiver(forWritingWithMutableData: $0).then {
                $0.requiresSecureCoding = true
                self.encodeSystemFieldsWithCoder($0)
                $0.finishEncoding()
            }
        }
    }

    public convenience init?(data: NSData) {
        let coder = NSKeyedUnarchiver(forReadingWithData: data)
        self.init(coder: coder)
        coder.finishDecoding()
    }
}