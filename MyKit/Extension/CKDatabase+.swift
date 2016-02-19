//
//  CKDatabase+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/18/16.
//  
//

public extension CKDatabase {

    public func fetch<T: CloudObject>() -> Future<CloudResult<T>> {
        return Future(operation: CKQueryOperation.fetch >>> self.addOperation)
    }

    public func fetch<T: CloudObject>(fromPrevResult result: CloudResult<T>) -> Future<CloudResult<T>>? {
        guard let operation = result.nextOperation else { return nil }
        return Future { _ in self.addOperation(operation) }
    }
}

private extension CKQueryOperation {

    class func fetch<T: CloudObject>(callback: Result<CloudResult<T>> -> Void) -> CKQueryOperation {
        return CKQueryOperation(callback: callback)
    }
}