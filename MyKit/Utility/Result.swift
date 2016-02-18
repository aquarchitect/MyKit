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

    public init(@noescape _ completion: Void throws -> T) {
        do { self = .Success(try completion()) }
        catch { self = .Failure(error) }
    }
}

public extension Result {

    public func map<U>(f: T throws -> U) -> Result<U> {
        switch self {

        case .Success(let value):
            do { return .Success(try f(value)) }
            catch { return .Failure(error) }

        case .Failure(let error): return .Failure(error)
        }
    }
}