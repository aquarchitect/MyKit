/*
 * Result.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

/// Constant that helps define results of a callback
public enum Result<T> {

    public typealias Callback = (Result) -> Void

    case fulfill(T)
    case reject(Error)

    public init(_ contruct: () throws -> T) {
        do { self = .fulfill(try contruct()) }
        catch { self = .reject(error) }
    }
}

public extension Result {

    var isFullfilled: Bool {
        switch self {
        case .fulfill(_): return true
        default: return false
        }
    }

    var isRejected: Bool {
        switch self {
        case .reject(_): return true
        default: return false
        }
    }
}

public extension Result {

    /// Unwrap in result into values
    func resolve() throws -> T {
        switch self {
        case .fulfill(let value): return value
        case .reject(let error): throw error
        }
    }
}

public extension Result {

    /// Transfrom the result of one type to another with a potential error
    func map<U>(_ transform: (T) throws -> U) -> Result<U> {
        switch self {
        case .fulfill(let value):
            do {
                return .fulfill(try transform(value))
            } catch {
                return .reject(error)
            }
        case .reject(let error):
            return .reject(error)
        }
    }

    func flatMap<U>(_ transform: (T) -> Result<U>) -> Result<U> {
        do {
            return transform(try resolve())
        } catch {
            return Result<U>.reject(error)
        }
    }
}

public extension Result {

    static func concat(_ results: [Result]) -> Result<[T]> {
        return results.reduce(.fulfill([])) {
            do {
                let result = (try $0.resolve()) + [try $1.resolve()]
                return .fulfill(result)
            } catch {
                return .reject(error)
            }
        }
    }
}

public func zip<A, B>(_ resultA: Result<A>, _ resultB: Result<B>) -> Result<(A, B)> {
    do {
        let a = try resultA.resolve()
        let b = try resultB.resolve()
        return .fulfill((a, b))
    } catch {
        return .reject(error)
    }
}
