/*
 * Result.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/// Constant that helps define results of a callback
public enum Result<T> {

    public typealias Callback = Result -> Void

    case Fullfill(T)
    case Reject(ErrorType)

    public init(@noescape f: () throws -> T) {
        do { self = .Fullfill(try f()) }
        catch { self = .Reject(error) }
    }
}

public extension Result {

    /// Unwrap in result into values
    func resolve() throws -> T {
        switch self {
        case .Fullfill(let value): return value
        case .Reject(let error): throw error
        }
    }
}

public extension Result {

    /// Transfrom the result of one type to another with a potential error
    func then<U>(f: T throws -> U) -> Result<U> {
        switch self {
        case .Fullfill(let value):
            do {
                return .Fullfill(try f(value))
            } catch {
                return .Reject(error)
            }
        case .Reject(let error):
            return .Reject(error)
        }
    }

    func andThen<U>(f: T -> Result<U>) -> Result<U> {
        do {
            return try (resolve >>> f)()
        } catch {
            return Result<U>.Reject(error)
        }
    }
}

public extension Result {

    static func zip(results: [Result]) -> Result<[T]> {
        return results.reduce(.Fullfill([])) {
            do {
                let result = (try $0.resolve()) + [try $1.resolve()]
                return .Fullfill(result)
            } catch {
                return .Reject(error)
            }
        }
    }
}

public func zip<A, B>(resultA: Result<A>, _ resultB: Result<B>) -> Result<(A, B)> {
    do {
        let a = try resultA.resolve()
        let b = try resultB.resolve()
        return .Fullfill((a, b))
    } catch {
        return .Reject(error)
    }
}