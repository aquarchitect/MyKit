/*
 * Collection+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

/// :nodoc:
internal extension Collection where Iterator.Element: Equatable, Index == Int {

    /*
     * Longest Common Sequence
     */
    func lcsMatrix<C: Collection>(byComparing other: C) -> Matrix<Index>
    where C.Iterator.Element == Iterator.Element, C.Index == Index {
        let rows = (self.count + 2).toIntMax()
        let columns = (other.count + 2).toIntMax()

            var matrix = Matrix(repeating: 1, rows: Int(rows), columns: Int(columns))
        matrix[row: 0] = Array(repeating: 0, count: Int(columns))
        matrix[column: 0] = Array(repeating: 0, count: Int(rows))

        for (i, thisElement) in self.enumerated() {
            for (j, otherElement) in other.enumerated() {
                if thisElement == otherElement {
                    matrix[i+2, j+2] = matrix[i+1, j+1] + 1
                } else {
                    matrix[i+2, j+2] = Swift.max(matrix[i+2, j+1], matrix[i+1, j+2])
                }
            }
        }

        return matrix
    }
}

public extension Collection where Iterator.Element: Equatable, Index == Int {

    func repeatingElements(byComparing other: Self) -> [Iterator.Element] {
        let matrix = lcsMatrix(byComparing: other)
        var common: [Iterator.Element] = []

        var i = Int(self.count.toIntMax())
        var j = Int(other.count.toIntMax())

        while i >= 1 && j >= 1 {
            switch matrix[i, j] {
            case matrix[i, j-1]:
                j -= 1
            case matrix[i-1, j]:
                i -= 1
            default:
                i -= 1
                j -= 1
                print(i)
                common.insert(self[i], at: 0)
            }
        }

        return common
    }

    typealias Step = (index: Index, element: Generator.Element)

    func backtrackChanges(byComparing other: Self) -> AnyIterator<Change<Step>> {
        let matrix = lcsMatrix(byComparing: other)

        var i = Int((self.count + 1).toIntMax())
        var j = Int((other.count + 1).toIntMax())

        return AnyIterator {
            while i >= 1 && j >= 1 {
                switch matrix[i, j] {
                case matrix[i, j-1]:
                    j -= 1
                    let step: Step = (j-1, other[j-1])
                    return .insert(step)
                case matrix[i-1, j]:
                    i -= 1
                    let step: Step = (i-1, self[i-1])
                    return .delete(step)
                default:
                    i -= 1
                    j -= 1
                }
            }

            return nil
        }
    }

    func compare(other: Self) -> [Change<Step>] {
        let count = Swift.max(self.count, other.count).toIntMax()

        var results: [Change<Step>] = []
        results.reserveCapacity(Int(count))

        backtrackChanges(byComparing: other).forEach {
            results.insert($0, at: 0)
        }

        return results
    }
}

public extension Collection where Iterator.Element: Equatable, Index == Int, SubSequence: Collection, SubSequence.Iterator.Element: Equatable, SubSequence.Index == Int {

    /**
     * This is designed for `UITableView` and `UICollecitonView`.
     * Warning: results are not in an order.
     */
    func compare(_ other: Self, section: Int) -> (reloads: [IndexPath], deletes: [IndexPath], inserts: [IndexPath]) {
        let count = Swift.max(self.count, other.count).toIntMax()

        var deletes = Set<IndexPath>(minimumCapacity: Int(count))
        var inserts = Set<IndexPath>(minimumCapacity: Int(count))
        var reloads = Set<IndexPath>(minimumCapacity: Int(count))

        backtrackChanges(byComparing: other).forEach {
            let change = $0.then { IndexPath(arrayLiteral: section, $0.index) }

            switch change {
            case .delete(let value) where inserts.contains(value):
                inserts.remove(value)
                reloads.insert(value)
            case .delete(let value):
                deletes.insert(value)
            case .insert(let value):
                inserts.insert(value)
            }
        }

        return (Array(reloads), Array(deletes), Array(inserts))
    }
}
