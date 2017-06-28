// 
// Collection+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

public extension Collection {

    typealias IndexTransformer<T> = (Index) -> T
}

public extension Collection where Index: SignedInteger {

    /// A view onto the collection with offseted indexes
    func offsetIndexes(by value: IndexDistance) -> OffsetCollection<Self> {
        return OffsetCollection(base: self, offsetValue: Int(value.toIntMax()))
    }
}

public extension Collection where Iterator.Element: Comparable {

    /// Returns an index of the first element using Binary Search algorithm.
    ///
    /// - Parameter element: a element to search for.
    /// - Warning: this should only be called on sorted collection
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

extension Collection where SubSequence.Iterator.Element: Equatable, Index == Int {

    typealias Ranges<I: Comparable> = (this: Range<I>, other: Range<I>)

    private var range: Range<Index> {
        return self.startIndex ..< self.endIndex
    }

    /// Return a tuple of collections' clamped ranges and a longest common subsequence (LCS) lookup table.
    ///
    /// - Parameters:
    ///     - other: a collection to compare with.
    ///     - range: a range for both collection to apply the algorithm on.
    ///       If `range` is `nil`, the operation will perform on the entire collections.
    func matrixUsingLCS<C>(byComparing other: C, in range: Range<Index>? = nil) -> (Ranges<Index>, Matrix<Index>) where
        C: Collection,
        C.Index == Index,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        let thisRange = self.range.clamped(to: range ?? self.range)
        let otherRange = other.range.clamped(to: range ?? other.range)

        let rows = thisRange.count + 2
        let columns = otherRange.count + 2

        var matrix = Matrix(repeating: 1, rows: Int(rows), columns: Int(columns))
        matrix[row: 0] = ArraySlice(repeating: 0, count: Int(columns))
        matrix[column: 0] = ArraySlice(repeating: 0, count: Int(rows))

        for (i, thisElement) in self[thisRange].enumerated() {
            for (j, otherElement) in other[otherRange].enumerated() {
                if thisElement == otherElement {
                    matrix[i+2, j+2] = matrix[i+1, j+1] + 1
                } else {
                    matrix[i+2, j+2] = Swift.max(matrix[i+2, j+1], matrix[i+1, j+2])
                }
            }
        }

        return ((thisRange, otherRange) as Ranges<Index>, matrix)
    }

    @available(*, deprecated, renamed: "matrixUsingLCS(byComparing:in:)")
    func lcsMatrix<C>(byComparing other: C, in range: Range<Index>? = nil) -> (Ranges<Index>, Matrix<Index>) where
        C: Collection,
        C.Index == Index,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return matrixUsingLCS(byComparing: other, in: range)
    }
}

public extension Collection where SubSequence.Iterator.Element: Equatable, Index == Int {

    /// Returns an array of elements that both collection contains.
    /// 
    /// - Parameters:
    ///     - other: a collection to compare with.
    ///     - range: a range for both collection to apply the algorithm on.
    ///       If `range` is `nil`, the operation will perform on the entire collections.
    func repeatingElementsUsingLCS<C>(byComparing other: C, in range: Range<Index>? = nil) -> [Iterator.Element] where
        C: Collection,
        C.Index == Index,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        let (ranges, matrix) = matrixUsingLCS(byComparing: other, in: range)

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

    @available(*, deprecated, renamed: "repeatingElementsUsingLCS(byComparing:in:)")
    func repeatingElements<C>(byComparing other: C, in range: Range<Index>? = nil) -> [Iterator.Element] where
        C: Collection,
        C.Index == Index,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return repeatingElementsUsingLCS(byComparing: other, in: range)
    }

    typealias Step = (index: Index, element: Generator.Element)

    /// Returns a tuple of collections' clamped ranges and longest common subsequence (LCS) diffing results.
    ///
    /// - Parameters:
    ///     - other: a collection to compare with.
    ///     - range: a range for both collection to apply the algorithm on.
    ///       If `range` is `nil`, the operation will perform on the entire collections.
    fileprivate func _backtrackChangesUsingLCS<C>(byComparing other: C, in range: Range<Index>? = nil) -> (Ranges<Index>, AnyIterator<LCS.Diff<Step>>) where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        let (ranges, matrix) = matrixUsingLCS(byComparing: other, in: range)

        var i = ranges.this.count + 1
        var j = ranges.other.count + 1

        let iterator = AnyIterator<LCS.Diff<Step>> {
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

    @available(*, deprecated, renamed: "_backtrackChangesUsingLCS(byComparing:in:)")
    fileprivate func _backtrackChanges<C>(byComparing other: C, in range: Range<Index>? = nil) -> (Ranges<Index>, AnyIterator<LCS.Diff<Step>>) where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return _backtrackChanges(byComparing: other, in: range)
    }

    /// Return an iterator of longest common subsquence (LCS) diffing results.
    ///
    /// - Parameters:
    ///     - other: a collection to compare with.
    ///     - range: a range for both collection to apply the algorithm on.
    ///       If `range` is `nil`, the operation will perform on the entire collections.
    func backtrackChangesUsingLCS<C>(byComparing other: C, in range: Range<Index>? = nil) -> AnyIterator<LCS.Diff<Step>> where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return _backtrackChangesUsingLCS(byComparing: other, in: range).1
    }

    @available(*, deprecated, renamed: "backtrackChangesUsingLCS(byComparing:in:)")
    func backtrackChanges<C>(byComparing other: C, in range: Range<Index>? = nil) -> AnyIterator<LCS.Diff<Step>> where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return backtrackChangesUsingLCS(byComparing: other, in: range)
    }

    /// Return an array of longest common subsequence LCS) diffing results.
    ///
    /// - Parameters:
    ///     - other: a collection to compare with.
    ///     - range: a range for both collection to apply the algorithm on.
    ///       If `range` is `nil`, the operation will perform on the entire collections.
    func compareUsingLCS<C>(_ other: C, in range: Range<Index>? = nil) -> [LCS.Diff<Step>] where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        let (ranges, changes) = _backtrackChangesUsingLCS(byComparing: other, in: range)
        let count = Swift.max(ranges.this.count, ranges.other.count)

        var results: [LCS.Diff<Step>] = []
        results.reserveCapacity(count)
        changes.forEach({ results.insert($0, at: 0) })

        return results
    }

    @available(*, deprecated, renamed: "compareUsingLCS(_:in:)")
    func compare<C>(_ other: C, in range: Range<Index>? = nil) -> [LCS.Diff<Step>] where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return compareUsingLCS(other, in: range)
    }
}

public extension Collection where SubSequence.Iterator.Element: Equatable, Index == Int {

    /// Return deleting and inserting indexes of longest common subsequence (LCS) diffing 
    /// results that can be used to update collection interfaces such as `UICollectionView`,
    /// `UITableView`, `NSTableView`, `NSCollectionView`.
    ///
    /// - Complexity: O(m * n)
    /// - Parameters:
    ///     - other: a collection to compare with.
    ///     - range: a range for both collection to apply the algorithm on.
    ///       If `range` is `nil`, the operation will perform on the entire collections.
    ///     - transformer: a block to apply diffing indexes with.
    /// - Note: the results have a guranteed order that can apply on `self` collection and 
    ///         produce `other` collection.
    func compareOptimallyUsingLCS<C, T>(_ other: C, in range: Range<Index>? = nil, transformer: IndexTransformer<T>) -> (deletes: [T], inserts: [T]) where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        let (_, changes) = _backtrackChangesUsingLCS(byComparing: other, in: range)
        var inserts = [T](), deletes = [T]()

        for change in changes {
            switch change.map({ transformer($0.index) }) {
            case .delete(let value): deletes.insert(value, at: deletes.startIndex)
            case .insert(let value): inserts.insert(value, at: inserts.startIndex)
            }
        }

        return (deletes, inserts)
    }

    @available(*, deprecated, renamed: "compareOptimallyUsingLCS(_:in:transformer:)")
    func compareOptimally<C, T>(_ other: C, in range: Range<Index>? = nil, transformer: IndexTransformer<T>) -> (deletes: [T], inserts: [T]) where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return compareOptimallyUsingLCS(other, in: range, transformer: transformer)
    }

    /// Similar to `compareOptimallyUsingLCS` but with interger index type.
    func compareOptimallyUsingLCS<C>(_ other: C, in range: Range<Index>? = nil) -> (deletes: [Int], inserts: [Int]) where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return compareOptimallyUsingLCS(other, in: range, transformer: Int.init(integerLiteral:))
    }

    @available(*, deprecated, renamed: "compareOptimallyUsingLCS(_:in:)")
    func compareOptimally<C>(_ other: C, in range: Range<Index>? = nil) -> (deletes: [Int], inserts: [Int]) where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return compareOptimallyUsingLCS(other, in: range, transformer: Int.init(integerLiteral:))
    }

    /// Return deleting and inserting indexes of longest common subsequence (LCS) diffing 
    /// results that are similar to `compareOptimallyUsingLCS`.
    func compareThoroughlyUsingLCS<C, T>(_ other: C, in range: Range<Index>? = nil, transformer: IndexTransformer<T>) -> (updates: [T], deletes: [T], inserts: [T]) where
        T: Comparable,
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        let (_, changes) = _backtrackChangesUsingLCS(byComparing: other, in: range)
        var updates = [T](), inserts = [T](), deletes = [T]()

        for change in changes {
            switch change.map({ transformer($0.index) }) {

            case .delete(let value):
                if let index = inserts.binarySearch(value) {
                    inserts.remove(at: index)
                    updates.insert(value, at: inserts.startIndex)
                } else {
                    deletes.insert(value, at: inserts.startIndex)
                }

            case .insert(let value):
                inserts.insert(value, at: inserts.startIndex)
            }
        }

        return (updates, deletes, inserts)
    }

    @available(*, deprecated, renamed: "compareThoroughlyUsingLCS(_:in:transformer:)")
    func compareThoroughly<C, T>(_ other: C, in range: Range<Index>? = nil, transformer: IndexTransformer<T>) -> (updates: [T], deletes: [T], inserts: [T]) where
        T: Comparable,
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return compareThoroughlyUsingLCS(other, in: range, transformer: transformer)
    }

    /// Similar to `compareThoroughlyUsingLCS` but with specific interger index type.
    func compareThoroughlyUsingLCS<C>(_ other: C, in range: Range<Index>? = nil) -> (updates: [Int], deletes: [Int], inserts: [Int]) where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return compareThoroughlyUsingLCS(other, in: range, transformer: Int.init(integerLiteral:))
    }

    @available(*, deprecated, renamed: "compareThoroughlyUsingLCS(_:in:)")
    func compareThoroughly<C>(_ other: C, in range: Range<Index>? = nil) -> (updates: [Int], deletes: [Int], inserts: [Int]) where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return compareThoroughlyUsingLCS(other, in: range, transformer: Int.init(integerLiteral:))
    }
}

public extension Collection where Iterator.Element: Hashable, IndexDistance == Int {

    /// Allows the enumeration on the results of Paul Heckel's isolating differences between files.
    ///
    /// - Parameters:
    ///     - other: a collection to compare with.
    ///     - block: a block to apply diffing result with.
    /// - See Also: [Paul Heckel's paper](http://documents.scribd.com/docs/10ro9oowpo1h81pgh1as.pdf)
    /// - Note: the return results can apply directly to the colelction interfaces.
    /// - Warning: there is no guarantee that the elements' order is reserved.
    func enumerateDiffStepsUsingHeckel<C>(byComparing other: C, block: (Heckel.Diff<Index>) -> Void) where
        C: Collection,
        C.Index == Index,
        C.IndexDistance == IndexDistance,
        C.Iterator.Element == Iterator.Element
    {
        var oa: [Heckel.Entry] = [], na: [Heckel.Entry] = []

        var table = Dictionary<Int, Heckel.Symbol>(minimumCapacity: Swift.max(self.count.hashValue, other.count.hashValue))

        // phase 1
        for element in other {
            let symbol = table[element.hashValue] ?? Heckel.Symbol()

            table[element.hashValue] = symbol
            symbol.nc.increment()
            na.append(.symbol(symbol))
        }

        // phase 2
        for (index, element) in self.enumerated() {
            let symbol = table[element.hashValue] ?? Heckel.Symbol()

            table[element.hashValue] = symbol
            symbol.then {
                $0.oc.increment()
                $0.olno.append(index)
            }
            oa.append(.symbol(symbol))
        }

        // phase 3
        for (newIndex, element) in na.enumerated() {
            guard case let .symbol(symbol) = element,
                symbol.andThen({ $0.occursInBoth && !$0.olno.isEmpty })
                else { continue }

            let oldIndex = symbol.olno.removeFirst()
            na[newIndex] = .index(oldIndex)
            oa[oldIndex] = .index(newIndex)
        }

        // phase 4
        for (i, element) in na.enumerated().dropFirst().dropLast() {
            guard case let .index(j) = element, j + 1 < oa.count,
                case let .symbol(newEntry) = na[i + 1],
                case let .symbol(oldEntry) = oa[j + 1],
                newEntry === oldEntry
                else { continue }

            na[i + 1] = .index(j + 1)
            oa[j + 1] = .index(i + 1)
        }

        // phase 5
        for (i, _) in na.enumerated().dropFirst().reversed() {
            guard case let .index(j) = na[i], j - 1 >= 0,
                case let .symbol(newEntry) = na[i - 1],
                case let .symbol(oldEntry) = oa[j - 1],
                newEntry === oldEntry
                else { continue }

            na[i - 1] = .index(j - 1)
            oa[j - 1] = .index(i - 1)
        }

        // obtain deletes elements
        var runningOffset = 0
        var deleteOffsets = Array(repeating: 0, count: self.count.hashValue)
        for (oldIndex, element) in oa.enumerated() {
            deleteOffsets[oldIndex] = runningOffset

            guard case .symbol = element else { continue }
            block(.delete(self.index(self.startIndex, offsetBy: oldIndex)))
            runningOffset += 1
        }

        // obtain other elements including: inserts, moves, and updates
        runningOffset = 0
        for (newIndex, element) in na.enumerated() {
            switch element {

            case .symbol:
                block(.insert(other.index(other.startIndex, offsetBy: newIndex)))
                runningOffset += 1

            case let .index(oldIndex):
                let oldElementIndex = self.index(self.startIndex, offsetBy: oldIndex)
                let newElementIndex = other.index(other.startIndex, offsetBy: newIndex)

                // update are elements that have same hash but are not equal
                if self[oldElementIndex] != other[newElementIndex] {
                    block(.update(newElementIndex))
                }

                if (oldIndex - deleteOffsets[oldIndex] + runningOffset) != newIndex {
                    block(.move(oldElementIndex, newElementIndex))
                }
            }
        }
    }

    /// Returns an array of Paul Heckel's diffing results.
    ///
    /// - Parameter other: a collection to compare with.
    /// - Note: the return results can apply directly to the colelction interfaces.
    /// - Warning: there is no guarantee that the elements' order is reserved.
    func compareUsingHeckel<C>(_ other: C) -> [Heckel.Diff<Index>] where
        C: Collection,
        C.Index == Index,
        C.IndexDistance == IndexDistance,
        C.Iterator.Element == Iterator.Element
    {
        var steps: [Heckel.Diff<Index>] = []
        enumerateDiffStepsUsingHeckel(byComparing: other) { steps.append($0) }
        return steps
    }

    /// Returns deletes, inserts, moves, and updates indexes of Paul Heckel diffing results.
    ///
    /// Updates are elements that have same hash but are not equal.
    ///
    /// - Parameters:
    ///     - other: a collection to compare with.
    ///     - block: a block to apply diffing result with.
    /// - Note: the return results can apply directly to the colelction interfaces.
    /// - Warning: there is no guarantee that the elements' order is reserved.
    func compareUsingHeckel<C, T>(_ other: C, transformer: IndexTransformer<T>) -> (deletes: [T], inserts: [T], moves: [(T, T)], updates: [T]) where
        C: Collection,
        C.Index == Index,
        C.IndexDistance == IndexDistance,
        C.Iterator.Element == Iterator.Element
    {
        var deletes = [T](), inserts = [T](), moves = [(T, T)](), updates = [T]()

        enumerateDiffStepsUsingHeckel(byComparing: other) {
            switch $0.map(transformer) {
            case .delete(let value): deletes.append(value)
            case .insert(let value): inserts.append(value)
            case .move(let values): moves.append(values)
            case .update(let value): updates.append(value)
            }
        }

        return (deletes, inserts, moves, updates)
    }
}

public extension Collection where Iterator.Element: Hashable, IndexDistance == Int, Index == Int {

    /// Similar to `compareUsingHeckel` but with specific interger index type.
    func compareUsingHeckel<C>(_ other: C) -> (deletes: [Int], inserts: [Int], moves: [(Int, Int)], updates: [Int]) where
        C: Collection,
        C.Index == Index,
        C.IndexDistance == IndexDistance,
        C.Iterator.Element == Iterator.Element
    {
        return compareUsingHeckel(other, transformer: Int.init(integerLiteral:))
    }
}
