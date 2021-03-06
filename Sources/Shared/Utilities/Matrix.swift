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
public struct Matrix<Element> {

    // MARK: Property
    fileprivate var elements: [Element]

    public let rows: Int
    public let columns: Int

    public var count: Int {
        return elements.count
    }

    // MARK: Initialization

    public init(repeating value: Element, rows: Int, columns: Int) {
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

    subscript(row: Int, column: Int) -> Element {
        get {
            assert(isValid(row: row, column: column), "Index out of bounds.")
            return elements[row * columns + column]
        }
        set {
            assert(isValid(row: row, column: column), "Index out of bounds")
            elements[row * columns + column] = newValue
        }
    }

    subscript(row row: Int) -> ArraySlice<Element> {
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

    subscript(column column: Int) -> ArraySlice<Element> {
        get {
            assert(column < columns, "Column out of bounds")

            let base = (0..<rows)
                .makeIterator()
                .lazy
                .map({ self.elements[$0 * self.columns + column] })

            return ArraySlice(base)
        }
        set {
            assert(column < columns, "Column out of bounds")
            assert(newValue.count == rows, "Row out of bounds")

            for index in 0..<rows {
                elements[index * columns + column] = newValue[index]
            }
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
