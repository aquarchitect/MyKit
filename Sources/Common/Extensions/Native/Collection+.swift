/*
 * Collection+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

extension Collection where Iterator.Element: Comparable {

    /*
     * The Swift core team has decided not to integrate binary search into
     * the language because of its complexity. Therefore, this implementation
     * is not made public in the meantime.
     */
    func binarySearch(_ element: Iterator.Element) -> Index? {
        func _binarySearch(in range: Range<Index>) -> Index? {
            guard range.lowerBound < range.upperBound else { return nil }
            let midIndex = self.index(range.lowerBound, offsetBy: self.count/2)

            switch self[midIndex] {
            case _ where element < self[midIndex]:
                let _range = Range(range.lowerBound ..< midIndex)
                return _binarySearch(in: _range)
            case _ where element > self[midIndex]:
                let _range = Range(self.index(after: range.lowerBound) ..< range.upperBound)
                return _binarySearch(in: _range)
            default:
                return midIndex
            }
        }

        return _binarySearch(in: self.startIndex..<self.endIndex)
    }
}

/// :nodoc:
extension Collection where SubSequence.Iterator.Element: Equatable, Index == Int {

    fileprivate var range: Range<Index> {
        return self.startIndex ..< self.endIndex
    }

    /*
     * Longest Common Sequence
     */
    func lcsMatrix<C: Collection>(byComparing other: C, in range: Range<Index>? = nil) -> Matrix<Index>
        where C.SubSequence.Iterator.Element == SubSequence.Iterator.Element, C.Index == Index
    {
        let thisRange = self.range.clamped(to: range ?? self.range)
        let otherRange = other.range.clamped(to: range ?? other.range)

        let rows = thisRange.count + 2
        let columns = otherRange.count + 2

        var matrix = Matrix(repeating: 1, rows: Int(rows), columns: Int(columns))
        matrix[row: 0] = Array(repeating: 0, count: Int(columns))
        matrix[column: 0] = Array(repeating: 0, count: Int(rows))

        for (i, thisElement) in self[thisRange].enumerated() {
            for (j, otherElement) in other[otherRange].enumerated() {
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

public extension Collection where SubSequence.Iterator.Element: Equatable, Index == Int {

    func repeatingElements(byComparing other: Self, in range: Range<Index>? = nil) -> [Iterator.Element] {
        let matrix = lcsMatrix(byComparing: other, in: range)

        let thisRange = self.range.clamped(to: range ?? self.range)
        let otherRange = other.range.clamped(to: range ?? other.range)

        func matrixLookup(at coord: (i: Int, j: Int), result: [Iterator.Element]) -> [Iterator.Element] {
            guard coord.i >= 2 && coord.j >= 2 else { return result }

            switch matrix[coord.i, coord.j] {
            case matrix[coord.i, coord.j-1]:
                return matrixLookup(at: (coord.i, coord.j-1), result: result)
            case matrix[coord.i-1, coord.j]:
                return matrixLookup(at: (coord.i-1, coord.j), result: result)
            default:
                let index = thisRange.lowerBound + coord.i - 2
                return matrixLookup(at: (coord.i-1, coord.j-1), result: [self[index]] + result)
            }
        }

        return matrixLookup(at: (thisRange.count + 1, otherRange.count + 1), result: [])
    }

    typealias Step = (index: Index, element: Generator.Element)

    func backtrackChanges(byComparing other: Self, in range: Range<Index>? = nil) -> AnyIterator<Change<Step>> {
        let matrix = lcsMatrix(byComparing: other, in: range)
        let thisRange = self.range.clamped(to: range ?? self.range)
        let otherRange = other.range.clamped(to: range ?? other.range)

        var i = thisRange.count + 1
        var j = otherRange.count + 1

        return AnyIterator {
            while i >= 1 && j >= 1 {
                switch matrix[i, j] {
                case matrix[i, j-1]:
                    j -= 1
                    let index = otherRange.lowerBound + j - 1
                    return .insert((index, other[index]))
                case matrix[i-1, j]:
                    i -= 1
                    let index = thisRange.lowerBound + i - 1
                    return .delete((index, self[index]))
                default:
                    i -= 1
                    j -= 1
                }
            }

            return nil
        }
    }

    func compare(_ other: Self, in range: Range<Index>? = nil) -> [Change<Step>] {
        let thisRange = self.range.clamped(to: range ?? self.range)
        let otherRange = other.range.clamped(to: range ?? other.range)

        let count = Swift.max(thisRange.count, otherRange.count)

        var results: [Change<Step>] = []
        results.reserveCapacity(count)

        backtrackChanges(byComparing: other, in: range).forEach {
            results.insert($0, at: 0)
        }

        return results
    }
}

public extension Collection where SubSequence.Iterator.Element: Equatable, Index == Int {

    func compareOptimally<C: RangeReplaceableCollection>(_ other: Self, in range: Range<Index>? = nil, indexTransformer transfomer: (Index) -> C.Iterator.Element) -> (deletes: C, inserts: C) {
        let thisRange = self.range.clamped(to: range ?? self.range)
        let otherRange = other.range.clamped(to: range ?? other.range)

        let count = C.IndexDistance(Swift.max(thisRange.count, otherRange.count).toIntMax())

        var inserts = C(); inserts.reserveCapacity(count)
        var deletes = C(); deletes.reserveCapacity(count)

        for change in self.backtrackChanges(byComparing: other, in: range) {
            switch (change.map { transfomer($0.index) }) {
            case .delete(let value): deletes.insert(value, at: deletes.startIndex)
            case .insert(let value): inserts.insert(value, at: inserts.startIndex)
            }
        }

        return (deletes, inserts)
    }

    func compareThoroughly<C: RangeReplaceableCollection>(_ other: Self, in range: Range<Index>? = nil, indexTransformer transformer: (Index) -> C.Iterator.Element) -> (reloads: C, deletes: C, inserts: C) where C.Iterator.Element: Comparable {
        let thisRange = self.range.clamped(to: range ?? self.range)
        let otherRange = other.range.clamped(to: range ?? other.range)

        let count = C.IndexDistance(Swift.max(thisRange.count, otherRange.count).toIntMax())

        var inserts = C(); inserts.reserveCapacity(count)
        var deletes = C(); deletes.reserveCapacity(count)
        var reloads = C(); reloads.reserveCapacity(count)

        for change in backtrackChanges(byComparing: other, in: range) {
            switch (change.map { transformer($0.index) }) {
            case .delete(let value):
                if let index = inserts.binarySearch(value) {
                    inserts.remove(at: index)
                    reloads.insert(value, at: inserts.startIndex)
                } else {
                    deletes.insert(value, at: inserts.startIndex)
                }
            case .insert(let value):
                inserts.insert(value, at: inserts.startIndex)
            }
        }

        return (reloads, deletes, inserts)
    }
}
