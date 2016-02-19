//
//  Future.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/18/16.
//  
//

public struct Future<T> {

    private let operation: Result<T>.Callback -> Void

    public init(operation: Result<T>.Callback -> Void) {
        self.operation = operation
    }
}

public extension Future {

    public func finish(callback: Result<T>.Callback) {
        self.operation(callback)
    }

    public func map<U>(f: T throws -> U) -> Future<U> {
        return Future<U> { callback in
            self.finish { callback($0.map(f)) }
        }
    }

    public func map<U>(f: T -> U) -> Future<U> {
        return Future<U> { callback in
            self.finish { callback($0.map(f)) }
        }
    }

    public func andThen<U>(f: T throws -> Future<U>) -> Future<U> {
        return Future<U> { callback in
            self.finish {
                do { try ($0.resolve >>> f)().finish(callback) }
                catch { callback(.Failure(error)) }
            }
        }
    }

    public func andThen<U>(f: T -> Future<U>) -> Future<U> {
        return Future<U> { callback in
            self.finish {
                do { try ($0.resolve >>> f)().finish(callback) }
                catch { callback(.Failure(error)) }
            }
        }
    }
}