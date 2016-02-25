//
//  Promise.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/18/16.
//  
//

public struct Promise<T> {

    private let operation: Result<T>.Callback -> Void

    public init(_ operation: Result<T>.Callback -> Void) {
        self.operation = operation
    }
}

public extension Promise {

    public func resolve(callback: Result<T>.Callback) {
        self.operation(callback)
    }

    public func then<U>(f: T -> U) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve { callback($0.then(f)) }
        }
    }

    public func then<U>(f: T throws -> U) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve { callback($0.then(f)) }
        }
    }

    public func andThen<U>(f: T -> Promise<U>) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve {
                do { try ($0.resolve >>> f)().resolve(callback) }
                catch { callback(.Reject(error)) }
            }
        }
    }

    public func andThen<U>(f: T throws -> Promise<U>) -> Promise<U> {
        return Promise<U> { callback in
            self.resolve {
                do { try ($0.resolve >>> f)().resolve(callback) }
                catch { callback(.Reject(error)) }
            }
        }
    }
}