/*
 * Collection+.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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

    func repeatingElements<C: Collection>(byComparing other: C) -> [Iterator.Element]
    where C.Iterator.Element == Iterator.Element, C.Index == Index {
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
                common.insert(self[i], at: 0)
            }
        }

        return common
    }
}

public extension Collection where Iterator.Element: Equatable, Index == Int {

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
        var results: [Change<Step>] = []

        backtrackChanges(byComparing: other).forEach {
            results.insert($0, at: 0)
        }

        return results
    }
}

#if os(Linux)
#else
import Foundation

public extension Collection where Iterator.Element: Equatable, Index == Int, SubSequence: Collection, SubSequence.Iterator.Element: Equatable, SubSequence.Index == Int {

    /**
     * This is designed for `UITableView` and `UICollecitonView`.
     */
    func compare(_ other: Self, range: CountableRange<Index>? = nil, section: Int) -> (reloads: [IndexPath], deletes: [IndexPath], inserts: [IndexPath]) {
        let count = Swift.max(self.count, other.count).toIntMax()

        let _deletes = NSMutableOrderedSet(capacity: Int(count))
        let _inserts = NSMutableOrderedSet(capacity: Int(count))

        backtrackChanges(byComparing: other).forEach {
            let change = $0.then { IndexPath(arrayLiteral: section, $0.index) }

            switch change {
            case .delete(let value): _deletes.insert(value, at: 0)
            case .insert(let value): _inserts.insert(value, at: 0)
            }
        }

        let reloads: [IndexPath] = {
            let deletes = NSMutableOrderedSet(orderedSet: _deletes, copyItems: true)
            deletes.intersect(_inserts)
            return deletes.array as? [IndexPath] ?? []
        }()

        let deletes: [IndexPath] = {
            let deletes = NSMutableOrderedSet(orderedSet: _deletes, copyItems: true)
            deletes.minus(_inserts)
            return deletes.array as? [IndexPath] ?? []
        }()

        let inserts: [IndexPath] = {
            let inserts = NSMutableOrderedSet(orderedSet: _inserts, copyItems: true)
            inserts.minus(_deletes)
            return inserts.array as? [IndexPath] ?? []
        }()
        
        return (reloads, deletes, inserts)
    }
}
#endif
