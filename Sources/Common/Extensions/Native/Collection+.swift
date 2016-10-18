/*
 * Collection+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

#if swift(>=3.0)
internal extension Collection where Iterator.Element: Comparable, Index == Int, IndexDistance == Int {

    /*
     * Due to the complexity of binary search implementation, the
     * core team rejects this proposal to the language. Therefore,
     * this extension will be kept internal for the time being.
     */
    func binarySearch(_ element: Iterator.Element) -> Index? {
        func _binarySearch(in range: Range<Index>) -> Index? {
            guard range.lowerBound < range.upperBound else { return nil }

            let midIndex = self.index(range.lowerBound, offsetBy: (range.upperBound - range.lowerBound)/2)

            switch self[midIndex] {
            case _ where element < self[midIndex]:
                let _range = Range(range.lowerBound..<midIndex)
                return _binarySearch(in: _range)
            case _ where element > self[midIndex]:
                let _range = Range((midIndex+1)..<range.upperBound)
                return _binarySearch(in: _range)
            default:
                return midIndex
            }
        }

        return _binarySearch(in: self.startIndex..<self.endIndex)
    }
}

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

        func matrixLookup(at coord: (i: Int, j: Int), result: [Iterator.Element]) -> [Iterator.Element] {
            guard coord.i >= 2 && coord.j >= 2 else { return result }

            switch matrix[coord.i, coord.j] {
            case matrix[coord.i, coord.j-1]:
                return matrixLookup(at: (coord.i, coord.j-1), result: result)
            case matrix[coord.i-1, coord.j]:
                return matrixLookup(at: (coord.i-1, coord.j), result: result)
            default:
                return matrixLookup(at: (coord.i-1, coord.j-1), result: [self[coord.i-2]] + result)
            }

        }

        let i = Int((self.count + 1).toIntMax())
        let j = Int((other.count + 1).toIntMax())
        return matrixLookup(at: (i, j), result: [])
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

    func compare(_ other: Self) -> [Change<Step>] {
        let count = Swift.max(self.count, other.count).toIntMax()

        var results: [Change<Step>] = []
        results.reserveCapacity(Int(count))

        backtrackChanges(byComparing: other).forEach {
            results.insert($0, at: 0)
        }

        return results
    }
}

public extension Collection where Iterator.Element: Equatable, Index == Int, SubSequence.Iterator.Element: Equatable {

    /**
     * This is designed for `UITableView` and `UICollecitonView`.
     */
    private func _compare(_ other: Self, section: Int) -> (reloads: [IndexPath], deletes: [IndexPath], inserts: [IndexPath]) {
        let count = Swift.max(self.count, other.count).toIntMax()

        var inserts: [IndexPath] = []; inserts.reserveCapacity(Int(count))
        var deletes: [IndexPath] = []; deletes.reserveCapacity(Int(count))
        var reloads: [IndexPath] = []; reloads.reserveCapacity(Int(count))

        backtrackChanges(byComparing: other).forEach {
            let change = $0.map { IndexPath(arrayLiteral: section, $0.index) }

            switch change {
            case .delete(let value):
                if let index = inserts.binarySearch(value) {
                    inserts.remove(at: index)
                    reloads.insert(value, at: 0)
                } else {
                    deletes.insert(value, at: 0)
                }
            case .insert(let value):
                inserts.insert(value, at: 0)
            }
        }

        return (reloads, deletes, inserts)
    }

    func compare(_ other: Self, range: CountableRange<Index>? = nil, section: Int) -> (reloads: [IndexPath], deletes: [IndexPath], inserts: [IndexPath]) {
        guard let _range = range else {
            return self._compare(other, section: section)
        }

        let thisRange = (self.startIndex ..< self.endIndex).clamped(to: _range)
        let otherRange = (other.startIndex ..< other.endIndex).clamped(to: _range)

        let thisCollection = self[thisRange].map { $0 }
        let otherCollection = other[otherRange].map { $0 }

        return thisCollection._compare(otherCollection, section: section)
    }
}
#else
#endif
