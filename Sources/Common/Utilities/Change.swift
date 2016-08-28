/*
 * Change.swift
 * MyKit
 *
 * Copyright (c) 2016 Hai Nguyen.
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

public enum Change<T> {

    case Reload(T)
    case Insert(T)
    case Delete(T)
}

public extension Change {

    var value: T {
        switch self {
        case .Reload(let value): return value
        case .Delete(let value): return value
        case .Insert(let value): return value
        }
    }

    func then<U>(f: T throws -> U) rethrows -> Change<U> {
        switch self {
        case .Reload(let value): return try .Reload(f(value))
        case .Delete(let value): return try .Delete(f(value))
        case .Insert(let value): return try .Insert(f(value))
        }
    }
}

public extension Change {

    var isReload: Bool {
        switch self {
        case .Reload(_): return true
        default: return false
        }
    }

    var isDelete: Bool {
        switch self {
        case .Delete(_): return true
        default: return false
        }
    }

    var isInsert: Bool {
        switch self {
        case .Insert(_): return true
        default: return false
        }
    }
}