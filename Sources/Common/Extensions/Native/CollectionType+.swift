/*
 * CollectionType+.swift
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

public extension CollectionType {

    /**
     * Returns the first element where predicate returns true for the corresponding value, or nil if such value is not found.
     */
    func find(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Generator.Element? {
        guard let index = try self.indexOf(predicate) else { return nil }
        return self[index]
    }
}

/// :nodoc:
internal extension CollectionType where Generator.Element: Equatable, Index == Int {

    /*
     * Longest Common Sequence
     */
    func lcsMatrix<C: CollectionType where C.Generator.Element == Generator.Element, C.Index == Index>(byComparing other: C) -> Matrix<Index> {
        let rows = self.count + 2
        let columns = other.count + 2

        var matrix = Matrix(rows: rows, columns: columns, repeatedValue: 1)
        matrix[row: 0] = Array(count: columns, repeatedValue: 0)
        matrix[column: 0] = Array(count: rows, repeatedValue: 0)

        for (i, thisElement) in self.enumerate() {
            for (j, otherElement) in other.enumerate() {
                if thisElement == otherElement {
                    matrix[i+2, j+2] = matrix[i+1, j+1] + 1
                } else {
                    matrix[i+2, j+2] = max(matrix[i+2, j+1], matrix[i+1, j+2])
                }
            }
        }

        return matrix
    }
}

public extension CollectionType where Generator.Element: Equatable, Index == Int {

    func repeatingElements<C: CollectionType where C.Generator.Element == Generator.Element, C.Index == Index>(byComparing other: C) -> [Generator.Element] {
        let matrix = lcsMatrix(byComparing: other)
        var i = self.count, j = other.count
        var common: [Generator.Element] = []

        while i >= 1 && j >= 1 {
            switch matrix[i, j] {
            case matrix[i, j-1]:
                j -= 1
            case matrix[i-1, j]:
                i -= 1
            default:
                i -= 1
                j -= 1
                common.insert(self[i], atIndex: 0)
            }
        }

        return common
    }
}

public extension CollectionType where Generator.Element: Equatable, Index == Int {

    typealias Step = (index: Index, element: Generator.Element)

    func backtrackChanges<C: CollectionType where C.Generator.Element == Generator.Element, C.Index == Index>(byComparing other: C, @noescape block: Change<Step> -> Void) {
        let matrix = lcsMatrix(byComparing: other)
        var i = self.count + 1, j = other.count + 1

        while i >= 1 && j >= 1 {
            switch matrix[i, j] {
            case matrix[i, j-1]:
                j -= 1
                let step: Step = (j-1, other[j-1])
                block(.Insert(step))
            case matrix[i-1, j]:
                i -= 1
                let step: Step = (i-1, self[i-1])
                block(.Delete(step))
            default:
                i -= 1
                j -= 1
            }
        }
    }

    func compare<C: CollectionType where C.Generator.Element == Generator.Element, C.Index == Index>(other: C) -> [Change<Step>] {
        var results: [Change<Step>] = []

        backtrackChanges(byComparing: other) {
            results.insert($0, atIndex: 0)
        }

        return results
    }
}

public extension CollectionType where Generator.Element: Equatable, Index == Int, SubSequence: CollectionType, SubSequence.Generator.Element: Equatable, SubSequence.Index == Int {

    /**
     * This is designed for `UITableView` and `UICollecitonView`.
     */
    func compare<C: CollectionType where C.Generator.Element == Generator.Element, C.Index == Index, C.SubSequence: CollectionType, C.SubSequence.Generator.Element == SubSequence.Generator.Element, C.SubSequence.Index == SubSequence.Index>(other: C, range: Range<Index>? = nil, inSection section: Int) -> (deletes: [NSIndexPath], inserts: [NSIndexPath]) {
        let oldRange = range?.intersects(self.indices) ?? self.indices
        let newRange = range?.intersects(other.indices) ?? other.indices

        var deletes: [NSIndexPath] = [], inserts: [NSIndexPath] = []

        (self[oldRange]).backtrackChanges(byComparing: other[newRange]) {
            let change = $0.then { NSIndexPath(indexes: 0, $0.index) }

            switch change {
            case .Delete(let value): deletes.insert(value, atIndex: 0)
            case .Insert(let value): inserts.insert(value, atIndex: 0)
            }
        }

        return (deletes, inserts)
    }
}