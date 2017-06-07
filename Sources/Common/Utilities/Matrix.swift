// 
// Matrix.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

/// Simple _Matrix_ to work with LCS algorithm (debugging purposes only).
///
/// - warning: reference [Surge](https://github.com/mattt/Surge) for optimized matrix computation.
public struct Matrix<T> {

    // MARK: Property
    fileprivate var elements: [T]

    public let rows: Int
    public let columns: Int

    public var count: Int {
        return elements.count
    }

    // MARK: Initialization

    public init(repeating value: T, rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.elements = Array(repeating: value, count: rows * columns)
    }
}

// MARK: - Support Methods

private extension Matrix {

    func isValid(row: Int, column: Int) -> Bool {
        return (0..<rows).contains(row) && (0..<columns).contains(column)
    }
}

// MARK: - Supscription

public extension Matrix {

    subscript(row: Int, column: Int) -> T {
        get {
            assert(isValid(row: row, column: column), "Index out of bounds.")
            return elements[row * columns + column]
        }
        set {
            assert(isValid(row: row, column: column), "Index out of bounds")
            elements[row * columns + column] = newValue
        }
    }

    subscript(row row: Int) -> ArraySlice<T> {
        get {
            assert(row < rows, "Row out of bounds.")
            let startIndex = row * columns
            let endIndex = startIndex + columns

            return elements[startIndex..<endIndex]
        }
        set {
            assert(row < rows, "Row out of bounds.")
            assert(newValue.count == columns, "Column out of bounds")
            let startIndex = row * columns
            let endIndex = startIndex + columns

            elements.replaceSubrange(startIndex..<endIndex, with: newValue)
        }
    }

    subscript(column column: Int) -> ArraySlice<T> {
        get {
            assert(column < columns, "Column out of bounds")
            return ArraySlice((0..<rows).map({ elements[$0 * columns + column] }))
        }
        set {
            assert(column < columns, "Column out of bounds")
            assert(newValue.count == rows, "Row out of bounds")
            (0..<rows).forEach { elements[$0 * columns + column] = newValue[$0] }
        }
    }
}

// MARK: - Custom String

extension Matrix: CustomDebugStringConvertible {

    public var debugDescription: String {
        let displayRow: (Int) -> String = { row in
            (0..<self.columns)
                .map { column in "\(self[row, column])" }
                .joined(separator: " ")
        }

        return (0..<rows)
            .map(displayRow)
            .joined(separator: "\n")
    }
}
