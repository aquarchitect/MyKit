//
//  Future.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/18/16.
//  
//

public struct Future<T> {

    public typealias Callback = Result<T> -> Void

    private let operation: Callback -> Void

    public init(operation: Callback -> Void) {
        self.operation = operation
    }
}

public extension Future {

    public func finish(callback: Callback) {
        self.operation(callback)
    }

    public func map<U>(f: T throws -> U) -> Future<U> {
        return Future<U> { callback in
            self.finish { callback($0.map(f)) }
        }
    }

    public func andThen<U>(f: T throws -> Future<U>) -> Future<U> {
        return Future<U> { callback in
            self.finish {
                switch $0 {

                case .Success(let value):
                    do { try f(value).finish(callback) }
                    catch { callback(.Failure(error)) }

                case .Failure(let error):
                    callback(.Failure(error))
                }
            }
        }
    }
}