/*
 * Collection+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

public extension Collection where Iterator.Element: Comparable {

    /// Return the first element of an ordered collection by using Binary Search algorithm
    func binarySearch(_ element: Iterator.Element) -> Index? {
        func _binarySearch(in range: Range<Index>) -> Index? {
            guard range.lowerBound < range.upperBound else { return nil }

            let distance = self.distance(from: range.lowerBound, to: range.upperBound)
            let midIndex = self.index(range.lowerBound, offsetBy: distance/2)

            switch self[midIndex] {
            case _ where element < self[midIndex]:
                let _range = range.lowerBound ..< midIndex
                return _binarySearch(in: _range)
            case _ where element > self[midIndex]:
                let _range = self.index(after: midIndex) ..< range.upperBound
                return _binarySearch(in: _range)
            default:
                return midIndex
            }
        }

        return _binarySearch(in: self.startIndex ..< self.endIndex)
    }
}

/// :nodoc:
extension Collection where SubSequence.Iterator.Element: Equatable, Index == Int {

    typealias Ranges = (this: Range<Index>, other: Range<Index>)

    private var range: Range<Index> {
        return self.startIndex ..< self.endIndex
    }

    /// Longest Common SubSequence Table
    func lcsMatrix<C: Collection>(byComparing other: C, in range: Range<Index>? = nil) -> (Ranges, Matrix<Index>) where
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element,
        C.Index == Index
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

        return ((thisRange, otherRange) as Ranges, matrix)
    }
}

public extension Collection where SubSequence.Iterator.Element: Equatable, Index == Int {

    func repeatingElements(byComparing other: Self, in range: Range<Index>? = nil) -> [Iterator.Element] {
        let (ranges, matrix) = lcsMatrix(byComparing: other, in: range)

        func matrixLookup(at coord: (i: Int, j: Int), result: [Iterator.Element]) -> [Iterator.Element] {
            guard coord.i >= 2 && coord.j >= 2 else { return result }

            switch matrix[coord.i, coord.j] {
            case matrix[coord.i, coord.j-1]:
                return matrixLookup(at: (coord.i, coord.j-1), result: result)
            case matrix[coord.i-1, coord.j]:
                return matrixLookup(at: (coord.i-1, coord.j), result: result)
            default:
                let index = ranges.this.lowerBound + coord.i - 2
                return matrixLookup(at: (coord.i-1, coord.j-1), result: [self[index]] + result)
            }
        }

        return matrixLookup(at: (ranges.this.count + 1, ranges.other.count + 1), result: [])
    }

    typealias Step = (index: Index, element: Generator.Element)

    fileprivate func _backtrackChanges(byComparing other: Self, in range: Range<Index>? = nil) -> (Ranges, AnyIterator<Diff<Step>>) {
        let (ranges, matrix) = lcsMatrix(byComparing: other, in: range)

        var i = ranges.this.count + 1
        var j = ranges.other.count + 1

        let iterator = AnyIterator<Diff<Step>> {
            while i >= 1 && j >= 1 {
                switch matrix[i, j] {
                case matrix[i, j-1]:
                    j -= 1
                    let index = ranges.other.lowerBound + j - 1
                    return .insert((index, other[index]))
                case matrix[i-1, j]:
                    i -= 1
                    let index = ranges.this.lowerBound + i - 1
                    return .delete((index, self[index]))
                default:
                    i -= 1
                    j -= 1
                }
            }

            return nil
        }

        return (ranges, iterator)
    }

    func backtrackChanges(byComparing other: Self, in range: Range<Index>? = nil) -> AnyIterator<Diff<Step>> {
        return _backtrackChanges(byComparing: other, in: range).1
    }

    func compare(_ other: Self, in range: Range<Index>? = nil) -> [Diff<Step>] {
        let (ranges, changes) = _backtrackChanges(byComparing: other, in: range)
        let count = Swift.max(ranges.this.count, ranges.other.count)

        var results: [Diff<Step>] = []
        results.reserveCapacity(count)
        changes.forEach { results.insert($0, at: 0) }

        return results
    }
}

public extension Collection where SubSequence.Iterator.Element: Equatable, Index == Int {

    typealias IndexTransformer<T> = (Index) -> T

    func compareOptimally<T>(_ other: Self, in range: Range<Index>? = nil, transformer: IndexTransformer<T>) -> (deletes: [T], inserts: [T]) {
        let (ranges, changes) = _backtrackChanges(byComparing: other, in: range)
        let count = Swift.max(ranges.this.count, ranges.other.count)

        var inserts = [T](); inserts.reserveCapacity(count)
        var deletes = [T](); deletes.reserveCapacity(count)

        for change in changes {
            switch (change.map { transformer($0.index) }) {
            case .delete(let value): deletes.insert(value, at: deletes.startIndex)
            case .insert(let value): inserts.insert(value, at: inserts.startIndex)
            }
        }

        return (deletes, inserts)
    }

    func compareThoroughly<T: Comparable>(_ other: Self, in range: Range<Index>? = nil, transformer: IndexTransformer<T>) -> (reloads: [T], deletes: [T], inserts: [T]) {
        let (ranges, changes) = _backtrackChanges(byComparing: other, in: range)
        let count = Swift.max(ranges.this.count, ranges.other.count)

        var inserts = [T](); inserts.reserveCapacity(count)
        var deletes = [T](); deletes.reserveCapacity(count)
        var reloads = [T](); reloads.reserveCapacity(count)

        for change in changes {
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
