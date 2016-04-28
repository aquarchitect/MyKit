//
//  CollectionType+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/16/16.
//  
//

public extension CollectionType where Index.Distance == Int {

    private func randomDistance() -> Index.Distance {
        return Int(arc4random_uniform(UInt32(self.count)))
    }

    public func randomElement() -> Generator.Element? {
        guard !self.isEmpty else { return nil }
        return self[self.startIndex.advancedBy(randomDistance())]
    }

    public func randomSequence() -> SubSequence {
        let startDistance = randomDistance()
        let startIndex = self.startIndex.advancedBy(startDistance)

        let endDistance = (startDistance..<self.count).randomElement() ?? startDistance
        let endIndex = self.startIndex.advancedBy(endDistance)

        return self[startIndex..<endIndex]
    }
}

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

    public func compare<C: CollectionType where C.Generator.Element == Generator.Element, C.Index == Index>(other: C) -> Diff<Generator.Element> {
        var matrix = self.commonSequenceMatrix(other)
        matrix = matrix.map { $0 + 1 }
        matrix.pad([.Top, .Left], repeatedValue: 0)

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