/*
 * CollectionType+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import Foundation

#if swift(>=3.0)
#else
public extension CollectionType {

    func find(condition: (Generator.Element) -> Bool) -> Generator.Element? {
        var result: Generator.Element?

        for element in self where condition(element) {
            result = element
            break
        }

        return result
    }
}

internal extension CollectionType where Generator.Element: Comparable, Index == Int, Index.Distance == Int {

    /*
     * Due to the complexity of binary search implementation, the
     * core team rejects this proposal to the language. Therefore,
     * this extension will be kept internal for the time being.
     */
    func binarySearch(element: Generator.Element) -> Index? {
        func _binarySearchIn(range: Range<Index>) -> Index? {
            guard range.startIndex < range.endIndex else { return nil }

            let midIndex = range.startIndex.advancedBy((range.endIndex - range.startIndex)/2)

            switch self[midIndex] {
            case _ where element < self[midIndex]:
                let _range = Range(range.startIndex..<midIndex)
                return _binarySearchIn(_range)
            case _ where element > self[midIndex]:
                let _range = Range((midIndex+1)..<range.endIndex)
                return _binarySearchIn(_range)
            default:
                return midIndex
            }
        }

        return _binarySearchIn(self.startIndex..<self.endIndex)
    }
}

/// :nodoc:
internal extension CollectionType where Generator.Element: Equatable, Index == Int {

    /*
     * Longest Common Sequence
     */
    func lcsMatrix<C: CollectionType where C.Generator.Element == Generator.Element, C.Index == Index>(byComparing other: C) -> Matrix<Index> {
            let rows = (self.count + 2).toIntMax()
            let columns = (other.count + 2).toIntMax()

            var matrix = Matrix(repeating: 1, rows: Int(rows), columns: Int(columns))
            matrix[row: 0] = Array(count: Int(columns), repeatedValue: 0)
            matrix[column: 0] = Array(count: Int(rows), repeatedValue: 0)

            for (i, thisElement) in self.enumerate() {
                for (j, otherElement) in other.enumerate() {
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

public extension CollectionType where Generator.Element: Equatable, Index == Int {

    func repeatingElements(byComparing other: Self) -> [Generator.Element] {
        let matrix = lcsMatrix(byComparing: other)

        func matrixLookup(at coord: (i: Int, j: Int), result: [Generator.Element]) -> [Generator.Element] {
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

    func backtrackChanges(byComparing other: Self) -> AnyGenerator<Change<Step>> {
        let matrix = lcsMatrix(byComparing: other)

        var i = Int((self.count + 1).toIntMax())
        var j = Int((other.count + 1).toIntMax())

        return AnyGenerator {
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
            results.insert($0, atIndex: 0)
        }

        return results
    }
}

public extension CollectionType where Generator.Element: Equatable, Index == Int, SubSequence.Generator.Element: Equatable {

    /**
     * This is designed for `UITableView` and `UICollecitonView`.
     */
    private func _compare(other: Self, section: Int) -> (reloads: [NSIndexPath], deletes: [NSIndexPath], inserts: [NSIndexPath]) {
        let count = Swift.max(self.count, other.count).toIntMax()

        var inserts: [NSIndexPath] = []; inserts.reserveCapacity(Int(count))
        var deletes: [NSIndexPath] = []; deletes.reserveCapacity(Int(count))
        var reloads: [NSIndexPath] = []; reloads.reserveCapacity(Int(count))

        backtrackChanges(byComparing: other).forEach {
            let change = $0.map { NSIndexPath(indexes: section, $0.index) }

            switch change {
            case .delete(let value):
                if let index = inserts.binarySearch(value) {
                    inserts.removeAtIndex(index)
                    reloads.insert(value, atIndex: 0)
                } else {
                    deletes.insert(value, atIndex: 0)
                }
            case .insert(let value):
                inserts.insert(value, atIndex: 0)
            }
        }

        return (reloads, deletes, inserts)
    }

    func compare(other: Self, range: Range<Index>? = nil, section: Int) -> (reloads: [NSIndexPath], deletes: [NSIndexPath], inserts: [NSIndexPath]) {
        guard let _range = range else {
            return self._compare(other, section: section)
        }

        let thisRange = (self.startIndex ..< self.endIndex).clampedTo(_range)
        let otherRange = (other.startIndex ..< other.endIndex).clampedTo(_range)
        
        let thisCollection = self[thisRange].map { $0 }
        let otherCollection = other[otherRange].map { $0 }
        
        return thisCollection._compare(otherCollection, section: section)
    }
}
#endif
