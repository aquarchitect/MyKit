/*
 * Matrix.swift
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

/**
 * Simple matrix for caching values of LCS algorithm.
 * Reference Surge for optimized matrix computing.
 */
public struct Matrix<T> {

    // MARK: Property

    private var elements: [T]

    public let rows: Int
    public let columns: Int

    public var count: Int {
        return elements.count
    }

    // MARK: Initialization

    public init(rows: Int, columns: Int, repeatedValue value: T) {
        self.rows = rows
        self.columns = columns
        self.elements = Array(count: rows * columns, repeatedValue: value)
    }
}

// MARK: - Support Methods

private extension Matrix {

    func isValidIndex(row: Int, _ column: Int) -> Bool {
        return (0..<rows).contains(row) && (0..<columns).contains(column)
    }
}

// MARK: - Supscription

public extension Matrix {

    subscript(row: Int, column: Int) -> T {
        get {
            assert(isValidIndex(row, column), "Index out of bounds.")
            return elements[row * columns + column]
        }
        set {
            assert(isValidIndex(row, column), "Index out of bounds")
            elements[row * columns + column] = newValue
        }
    }

    subscript(row row: Int) -> [T] {
        get {
            assert(row < rows, "Row out of bounds.")
            let startIndex = row * columns
            let endIndex = startIndex + columns
            return Array(elements[startIndex..<endIndex])
        }
        set {
            assert(row < rows, "Row out of bounds.")
            assert(newValue.count == columns, "Column out of bounds")
            let startIndex = row * columns
            let endIndex = startIndex + columns
            elements.replaceRange(startIndex..<endIndex, with: newValue)
        }
    }

    subscript(column column: Int) -> [T] {
        get {
            assert(column < columns, "Column out of bounds")
            return (0..<rows).map { elements[$0 * columns + column] }
        }
        set {
            assert(column < columns, "Column out of bounds")
            assert(newValue.count == rows, "Row out of bounds")
            (0..<rows).forEach { elements[$0 * columns + column] = newValue[$0] }
        }
    }
}

extension Matrix: CustomDebugStringConvertible {

    public var debugDescription: String {
        let displayRow: Int -> String = { row in
            (0..<self.columns)
                .map { column in "\(self[row, column])" }
                .joinWithSeparator(" ")
        }

        return (0..<rows)
            .map(displayRow)
            .joinWithSeparator("\n")
    }
}