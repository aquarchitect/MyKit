//
//  Matrix.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/27/16.
//  
//

public struct Matrix<T: CustomStringConvertible> {

    private var elements: [[T]]

    public init(rows: Int, columns: Int, value: T) {
        self.elements = (0..<rows).map { _ in (0..<columns).map { _ in value }}
    }

    subscript(rows: Int, columns: Int) -> T {
        get { return elements[rows][columns] }
        set { elements[rows][columns] = newValue }
    }
}

extension Matrix: CustomDebugStringConvertible {

    public var debugDescription: String {
        return elements.map { $0.map { $0.description }.joinWithSeparator(" ") }.joinWithSeparator("\n")
    }
}