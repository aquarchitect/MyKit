/*
 * Result.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

private struct NoContent: Error {}

/// _Result_ helps defining results of a callback.
public enum Result<T> {

    public typealias Callback = (Result) -> Void

    case fulfill(T)
    case reject(Error)

    public init(_ contruct: () throws -> T) {
        do {
            self = .fulfill(try contruct())
        } catch {
            self = .reject(error)
        }
    }

    init(_ value: T?, _ error: Error?) {
        if let _error = error {
            self = .reject(_error)
        } else if let _value = value {
            self = .fulfill(_value)
        } else {
            self = .reject(Empty())
        }
    }
}

// MARK: - Attributes

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

// MARK: - Resolving

public extension Result {

    /// Unwrap in result into values
    func resolve() throws -> T {
        switch self {
        case .fulfill(let value): return value
        case .reject(let error): throw error
        }
    }
}

// MARK: - Transformation

public extension Result {

    /// Transfrom result of one type to another
    func map<U>(_ transformer: (T) throws -> U) -> Result<U> {
        switch self {
        case .fulfill(let value):
            do {
                return .fulfill(try transformer(value))
            } catch {
                return .reject(error)
            }
        case .reject(let error):
            return .reject(error)
        }
    }

    /// Transform result of one type to another
    func flatMap<U>(_ transformer: (T) -> Result<U>) -> Result<U> {
        do {
            return transformer(try resolve())
        } catch {
            return Result<U>.reject(error)
        }
    }
}

// MARK: - Multiple Results

public extension Result {

    private static func _concat(results: [Result]) -> Result<[T]> {
        return results.reduce(.fulfill([])) {
            do {
                let result = (try $0.resolve()) + [try $1.resolve()]
                return .fulfill(result)
            } catch {
                return .reject(error)
            }
        }
    }

    /// Flattern results of the same type to a result of collection type
    static func concat(_ results: [Result]) -> Result<[T]> {
        return _concat(results: results)
    }
}

/// Combine results of 2 different types into result of a tuple
func _zip<A, B>(resultA: Result<A>, resultB: Result<B>) -> Result<(A, B)> {
    do {
        let a = try resultA.resolve()
        let b = try resultB.resolve()
        return .fulfill((a, b))
    } catch {
        return .reject(error)
    }
}
public func zip<A, B>(_ resultA: Result<A>, _ resultB: Result<B>) -> Result<(A, B)> {
    return _zip(resultA: resultA, resultB: resultB)
}
