//
//  Promise.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/18/16.
//  
//

public class Promise<T> {

    private let callback: Void -> Result<T>

    public init(_ callback: Void throws -> T) {
        self.callback = { Result(callback) }
    }

    private init(_ callback: Void -> Result<T>) {
        self.callback = callback
    }

    public func then<U>(callback: T throws -> U) -> Promise<U> {
        return Promise<U> { self.callback().map(callback) }
    }

    public func finish(callback: Result<T> -> Void) {
        (self.callback --> callback)()
    }

    public func succeed(callback: T -> Void) {
        if case .Success(let value) = self.callback() { callback(value) }
    }

    public func fail(callback: ErrorType -> Void) {
        if case .Failure(let error) = self.callback() { callback(error) }
    }
}