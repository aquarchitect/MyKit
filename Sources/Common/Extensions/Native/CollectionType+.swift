/*
 * CollectionType+.swift
 * MyKit
 *
 * Copyright (c) 2015–2016 Hai Nguyen
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

    /// Returns the first element where predicate returns true for the corresponding value, or nil if such value is not found.
    func find(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Generator.Element? {
        guard let index = try self.indexOf(predicate) else { return nil }
        return self[index]
    }
}

/// :nodoc:
public extension CollectionType where Generator.Element: Equatable, Index == Int {

    internal func commonSequenceMatrix<C: CollectionType where C.Generator.Element == Generator.Element, C.Index == Index>(other: C) -> Matrix<Index> {
        let rows = self.count + 1
        let columns = other.count + 1

        var matrix = Matrix(rows: rows, columns: columns, repeatedValue: 0)

        for (i, thisElem) in self.enumerate() {
            for (j, otherElem) in other.enumerate() {
                if thisElem == otherElem {
                    matrix[i+1, j+1] = matrix[i, j] + 1
                } else {
                    matrix[i+1, j+1] = max(matrix[i+1, j], matrix[i, j+1])
                }
            }
        }

        return matrix
    }

    func compare<C: CollectionType where C.Generator.Element == Generator.Element, C.Index == Index>(other: C) -> Diff<Generator.Element> {
        let matrix = commonSequenceMatrix(other)
            .map { $0 + 1 }
            .pad([.Top, .Left], repeatedValue: 0)

        var i = self.count + 1, j = other.count + 1

        var insertion: [Diff<Generator.Element>.Step] = []
        var deletion: [Diff<Generator.Element>.Step] = []

        while i >= 1 && j >= 1 {
            switch matrix[i, j] {
            case matrix[i, j-1]:
                j -= 1
                insertion += [(j-1, other[j-1])]
            case matrix[i-1, j]:
                i -= 1
                deletion += [(i-1, self[i-1])]
            default:
                i -= 1
                j -= 1
            }
        }

        return Diff(deletion: deletion.reverse(), insertion: insertion.reverse())
    }
}