/*
 * CloudRecord.swift
 *
 * Copyright (c) 2015–2016 Hai Nguyen (http://aquarchitect.github.io)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import CloudKit

private enum Exception: ErrorType {

    case MissedMatch
    case NotUserType
}

public protocol CloudRecord: class {}

private extension CloudRecord where Self: NSObject {

    func decodeFrom(record: CKRecord) {
        for key in record.allKeys() where self.respondsToSelector(Selector(key)) {
            guard let value = record[key] else { continue }
            self.setValue(value, forKey: key)
        }
    }

    func encodeTo(record: CKRecord) {
        var count: UInt32 = 0
        let props = class_copyPropertyList(self.dynamicType, &count)

        (0..<Int(count)).flatMap {
            let string = property_getName(props[$0])
            return String(CString: string, encoding: NSUTF8StringEncoding)
        }.lazy.forEach {
            record[$0] = self.valueForKey($0) as? CKRecordValue
        }

        free(props)
    }
}

public class CloudObject: NSObject, CloudRecord {

    public let metadata: NSData?

    public init(record: CKRecord, cacheMetadata flag: Bool) throws {
        if record.recordType != String(self.dynamicType) {
            throw Exception.MissedMatch
        }

        self.metadata = flag ? record.metadata : nil
        super.init()

        decodeFrom(record)
    }

    public override init() {
        self.metadata = nil
        super.init()
    }

    public func toRecord() -> CKRecord? {
        return metadata?
            .then { CKRecord(data: $0) }?
            .then(encodeTo)
    }
}

public class CloudUser: NSObject, CloudRecord {

    public let metadata: NSData

    public init(record: CKRecord) throws {
        if record.recordType != CKRecordTypeUserRecord {
            throw Exception.NotUserType
        }

        self.metadata = record.metadata
        super.init()

        decodeFrom(record)
    }

    public func toRecord() -> CKRecord {
        return metadata
            .then { CKRecord(data: $0) }!
            .then(encodeTo)
    }
}