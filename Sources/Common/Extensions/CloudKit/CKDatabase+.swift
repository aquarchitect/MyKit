/*
 * CKDatabase+.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
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

public extension CKDatabase {

    func fetchCurrentUser() -> Promise<CKRecord> {
        return Promise({ callback in
            let operation = CKFetchRecordsOperation.fetchCurrentUserRecordOperation()
            operation.perRecordCompletionBlock = {
                if let error = $2 {
                    callback(.reject(error))
                } else if let record = $0 {
                    callback(.fullfill(record))
                } else {
                    callback(.reject(PromiseError.noData))
                }
            }
            return operation
        } >>> self.add)
    }
}

public extension CKDatabase {

    private func transform<T>(_ callback: @escaping Result<T>.Callback) -> (T?, Error?) -> Void {
        return {
            if let error = $1 {
                callback(.reject(error))
            } else if let result = $0 {
                callback(.fullfill(result))
            } else {
                callback(.reject(PromiseError.noData))
            }
        }
    }

    public func save(record: CKRecord) -> Promise<CKRecord> {
        return Promise(transform >>> { self.save(record, completionHandler: $0) })
    }

    public func delete(recordID: CKRecordID) -> Promise<CKRecordID> {
        return Promise(transform >>> { self.delete(withRecordID: recordID, completionHandler: $0) })
    }

    public func fetch(recordID: CKRecordID) -> Promise<CKRecord> {
        return Promise(transform >>> { self.fetch(withRecordID: recordID, completionHandler: $0) })
    }

    public func perform(query: CKQuery, zone: CKRecordZoneID? = nil) -> Promise<[CKRecord]> {
        return Promise(transform >>> { self.perform(query, inZoneWith: zone, completionHandler: $0) })
    }
}
