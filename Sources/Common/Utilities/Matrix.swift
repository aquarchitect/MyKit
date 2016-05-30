//
//  Matrix.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/27/16.
//  
//

public struct Matrix<T> {

    // MARK: Property

    public private(set) var elements: [T]

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

    public init(rows: Int, columns: Int, elements: [T]) {
        precondition(elements.count == rows * columns)

        self.rows = rows
        self.columns = columns
        self.elements = elements
    }

    public init(elements: [[T]]) {
        let columns = elements.minElement { $0.count < $1.count }?.count ?? 0

        self.columns = columns
        self.rows = elements.count
        self.elements = elements.flatMap { $0[0..<columns] }
    }

    // MARK: Support Method

    private func isValidIndex(row: Int, _ column: Int) -> Bool {
        return (0..<rows).contains(row) && (0..<columns).contains(column)
    }

    public subscript(row: Int, column: Int) -> T {
        get {
            // print(row, column, rows, columns)
            precondition(isValidIndex(row, column), "Index out of bounds.")
            return elements[row * columns + column]
        }
        set {
            // print(row, column, rows, columns)
            precondition(isValidIndex(row, column), "Index out of bounds")
            elements[row * columns + column] = newValue
        }
    }
}

public extension Matrix {

    @warn_unused_result
    public func map<U>(f: T throws -> U) rethrows -> Matrix<U> {
        return Matrix<U>(rows: rows, columns: columns, elements: try self.elements.map(f))
    }

    @warn_unused_result
    public func transposing() -> Matrix<T> {
        return Matrix(elements: (0..<columns).map { column in (0..<rows).map { row in self[row, column] }})
    }

    @warn_unused_result
    public func padding(sides: [Side], repeatedValue value: T) -> Matrix<T> {
        var rows = self.rows, columns = self.columns, elements = self.elements

        for side in sides {
            switch side {
            case .Top:
                rows += 1
                elements = Array(count: columns, repeatedValue: value) + elements
            case .Left:
                columns += 1
                (0..<rows).forEach { elements.insert(value, atIndex: $0 * columns) }
            case .Bottom:
                rows += 1
                elements += Array(count: columns, repeatedValue: value)
            case .Right:
                columns += 1
                (1...rows).forEach { elements.insert(value, atIndex: $0 * columns) }
            }
        }

        return Matrix<T>(rows: rows, columns: columns, elements: elements)
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