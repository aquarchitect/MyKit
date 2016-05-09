//
//  Matrix.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/27/16.
//  
//

public struct Matrix<T: CustomStringConvertible> {

    private var elements: [[T]]

    public init(rows: Int, columns: Int, repeatedValue value: T) {
        self.elements = (0..<rows).map { _ in (0..<columns).map { _ in value }}
    }

    private init() {
        self.elements = []
    }

    public subscript(rows: Int, columns: Int) -> T {
        get { return elements[rows][columns] }
        set { elements[rows][columns] = newValue }
    }
}

public extension Matrix {

    public func map<U: CustomStringConvertible>(f: T throws -> U) rethrows -> Matrix<U> {
        var results = Matrix<U>()
        results.elements = try elements.map { try $0.map(f) }
        return results
    }

    public mutating func pad(sides: [Side], repeatedValue value: T) {
        for side in sides {
            switch side {
            case .Top: elements.insert(elements.first?.map { _ in value } ?? [], atIndex: 0)
            case .Left: elements = elements.map { [value] + $0 }
            case .Bottom: elements.append(elements.last?.map { _ in value } ?? [])
            case .Right: elements = elements.map { $0 + [value] }
            }
        }
    }
}

extension Matrix: CustomDebugStringConvertible {

    public var debugDescription: String {
        return elements.map { $0.map { $0.description }.joinWithSeparator(" ") }.joinWithSeparator("\n")
    }
}