//
//  Matrix+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/1/16.
//  
//

import Surge

public extension Matrix {

    func pad(sides: [Side]) -> Matrix<T> {
        var rows = self.rows, columns = self.columns
        var topMargin = 0, leftMargin = 0

        sides.forEach {
            switch $0 {
            case .Top:
                topMargin += 1
                fallthrough
            case .Bottom:
                rows += 1
            case .Left:
                leftMargin += 1
                fallthrough
            case .Right:
                columns += 1
            }
        }

        var result = Matrix<T>(rows: rows, columns: columns, repeatedValue: 0.0)
        for i in 0..<rows {
            var content = Array<T>(count: columns, repeatedValue: 0.0)

            if (topMargin..<(topMargin + self.rows)) ~= i {
                let range = leftMargin..<(leftMargin + self.columns)
                content.replaceRange(range, with: self[row: i - topMargin])
            }

            result[row: i] = content
        }

        return result
    }
}