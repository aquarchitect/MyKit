/*
 * CloudCategorical.swift
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

// TODO: Redesign CloudKit

public protocol CloudCategorical {

    associatedtype Element
    var element: Element { get }
    init(record: CKRecord, cachedMetadata flag: Bool) throws
}

public extension CloudCategorical where Element: CloudObject {

    typealias Callback = Result<([Self], CKQueryCursor?)>.Callback

    static func fetch(cachedMetadata flag: Bool, callback: Callback) -> CKQueryOperation {
        var results: [Self] = []

        let operation = CKQueryOperation()
        operation.recordFetchedBlock = {
            results += [try? Self(record: $0, cachedMetadata: flag)].flatMap { $0 }
        }
        operation.queryCompletionBlock = {
            if let error = $1 {
                callback(.Reject(error))
            } else {
                callback(.Fullfill((results, $0)))
            }
        }

        return operation
    }

    static func fetch(cachedMetadata flag: Bool, predicate: NSPredicate) -> (Callback -> CKDatabaseOperation) {
        return { fetch(cachedMetadata: flag, callback: $0).then { $0.query = CKQuery(recordType: Element.self, predicate: predicate) }}
    }

    static func fetch(cachedMetadata flag: Bool, cursor: CKQueryCursor) -> (Callback -> CKDatabaseOperation) {
        return { fetch(cachedMetadata: flag, callback: $0).then { $0.cursor = cursor }}
    }
}