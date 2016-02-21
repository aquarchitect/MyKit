//
//  Result.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/18/16.
//  
//

public enum Result<T> {

    case Success(T)
    case Failure(ErrorType)
}

public extension Result {

    typealias Callback = Result -> Void

    public func map<U>(f: T throws -> U) -> Result<U> {
        switch self {

        case .Success(let value):
            do { return .Success(try f(value)) }
            catch { return .Failure(error) }

        case .Failure(let error):
            return .Failure(error)
        }
    }

    public func map<U>(f: T -> U) -> Result<U> {
        switch self {

        case .Success(let value): return .Success(f(value))
        case .Failure(let error): return .Failure(error)
        }
    }

    public func resolve() throws -> T {
        switch self {

        case .Success(let value): return value
        case .Failure(let error): throw error
        }
    }
}