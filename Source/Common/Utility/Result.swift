//
//  Result.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/18/16.
//  
//

/// Constant that helps define results of a callback
public enum Result<T> {

    case Fullfill(T)
    case Reject(ErrorType)
}

public extension Result {

    typealias Callback = Result -> Void

    /// Tranform the result of one type to another
    public func then<U>(f: T -> U) -> Result<U> {
        switch self {

        case .Fullfill(let value): return .Fullfill(f(value))
        case .Reject(let error): return .Reject(error)
        }
    }

    /// Transfrom the result of one type to another with a potential error
    public func then<U>(f: T throws -> U) -> Result<U> {
        switch self {

        case .Fullfill(let value):
            do { return .Fullfill(try f(value)) }
            catch { return .Reject(error) }

        case .Reject(let error):
            return .Reject(error)
        }
    }

    /// Unwrap in result into values
    public func resolve() throws -> T {
        switch self {

        case .Fullfill(let value): return value
        case .Reject(let error): throw error
        }
    }
}