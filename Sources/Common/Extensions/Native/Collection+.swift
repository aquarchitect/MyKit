// 
// Collection+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

// Paul Heckel's isolating differences between files
// (http://documents.scribd.com/docs/10ro9oowpo1h81pgh1as.pdf)
// was implemented as Collection extension, but it is removed
// as favored Longest Common Subsequence.

public extension Collection {

    typealias IndexTransformer<T> = (Index) -> T
}

public extension Collection {

    func permutate<S>(with indexes: S) -> PermutationSlice<Self> where
        S: Sequence,
        S.Iterator.Element == Index
    {
        return PermutationSlice(base: self, permutatedIndexes: indexes)
    }

    func enumerate(inline block: @escaping (Index, Iterator.Element) -> Iterator.Element) -> EnumeratedCollection<Self> {
        return EnumeratedCollection(base: self, block: block)
    }
}

public extension Collection where Index: SignedInteger {

    /// A view onto the collection with offseted indexes
    func offsetIndexes(by value: Index.Stride) -> OffsetCollection<Self> {
        return OffsetCollection(base: self, offsetValue: value)
    }

    func group<U: Hashable>(by predicate: (Iterator.Element) -> U) -> [U: PermutationSlice<Self>] {
        var result = Dictionary<U, PermutationSlice<Self>>(minimumCapacity: self.count.hashValue)

        for (index, element) in self.enumerated() {
            let key = predicate(element)
            let indexes = (result[key]?.permutatedIndexes ?? []) + [
                self.startIndex.advanced(by: index)
            ]

            result[key] = PermutationSlice(base: self, permutatedIndexes: indexes)
        }

        return result
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

extension Collection where SubSequence.Iterator.Element: Hashable, Index: _Strideable, Index.Stride: SignedInteger {

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
    func matrix<C>(byLCSComparing other: C, in range: Range<Index>? = nil) -> (Ranges<Index>, Matrix<Int>) where
        C: Collection,
        C.Index == Index,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        let thisRange = self.range.clamped(to: range ?? self.range)
        let otherRange = other.range.clamped(to: range ?? other.range)

        let rows = (thisRange.count + 2).hashValue
        let columns = (otherRange.count + 2).hashValue

        var matrix = Matrix(repeating: 1, rows: rows, columns: columns)
        matrix[row: 0] = ArraySlice(repeating: 0, count: columns)
        matrix[column: 0] = ArraySlice(repeating: 0, count: rows)

        for (i, thisElement) in self[thisRange].enumerated() {
            for (j, otherElement) in other[otherRange].enumerated() {
                if thisElement.hashValue == otherElement.hashValue {
                    matrix[i+2, j+2] = matrix[i+1, j+1] + 1
                } else {
                    matrix[i+2, j+2] = Swift.max(matrix[i+2, j+1], matrix[i+1, j+2])
                }
            }
        }

        return ((thisRange, otherRange) as Ranges<Index>, matrix)
    }

    @available(*, deprecated, renamed: "matrix(byLCSComparing:in:)")
    func lcsMatrix<C>(byComparing other: C, in range: Range<Index>? = nil) -> (Ranges<Index>, Matrix<Int>) where
        C: Collection,
        C.Index == Index,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return matrix(byLCSComparing: other, in: range)
    }
}

public extension Collection where SubSequence.Iterator.Element: Hashable, Index: _Strideable, Index.Stride: SignedInteger {

    /// Returns an array of elements that both collection contains.
    /// 
    /// - Parameters:
    ///     - other: a collection to compare with.
    ///     - range: a range for both collection to apply the algorithm on.
    ///       If `range` is `nil`, the operation will perform on the entire collections.
    func repeatingElements<C>(byLCSComparing other: C, in range: Range<Index>? = nil) -> [Iterator.Element] where
        C: Collection,
        C.Index == Index,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        let (ranges, matrix) = self.matrix(byLCSComparing: other, in: range)

        func matrixLookup(at coord: (i: Index.Stride, j: Index.Stride), result: [Iterator.Element]) -> [Iterator.Element] {
            guard coord.i >= 2 && coord.j >= 2 else { return result }

            switch matrix[coord.i.hashValue, coord.j.hashValue] {
            case matrix[coord.i.hashValue, (coord.j-1).hashValue]:
                return matrixLookup(at: (coord.i, coord.j-1), result: result)
            case matrix[(coord.i-1).hashValue, coord.j.hashValue]:
                return matrixLookup(at: (coord.i-1, coord.j), result: result)
            default:
                let index = ranges.this.lowerBound.advanced(by: coord.i - 2)
                return matrixLookup(at: (coord.i-1, coord.j-1), result: [self[index]] + result)
            }
        }

        return matrixLookup(at: (ranges.this.count + 1, ranges.other.count + 1), result: [])
    }

    @available(*, deprecated, renamed: "repeatingElements(byLCSComparing:in:)")
    func repeatingElementsUsingLCS<C>(byComparing other: C, in range: Range<Index>? = nil) -> [Iterator.Element] where
        C: Collection,
        C.Index == Index,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return repeatingElements(byLCSComparing: other, in: range)
    }

    @available(*, deprecated, renamed: "repeatingElements(byLCSComparing:in:)")
    func repeatingElements<C>(byComparing other: C, in range: Range<Index>? = nil) -> [Iterator.Element] where
        C: Collection,
        C.Index == Index,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return repeatingElements(byLCSComparing: other, in: range)
    }

    typealias Step = (index: Index, element: Generator.Element)

    /// Returns a tuple of collections' clamped ranges and longest common subsequence (LCS) diffing results.
    ///
    /// - Parameters:
    ///     - other: a collection to compare with.
    ///     - range: a range for both collection to apply the algorithm on.
    ///       If `range` is `nil`, the operation will perform on the entire collections.
    fileprivate func _backtrackChanges<C>(byLCSComparing other: C, in range: Range<Index>? = nil) -> (Ranges<Index>, AnyIterator<Diff<Step>>) where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.Iterator.Element: Equatable,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        let (ranges, matrix) = self.matrix(byLCSComparing: other, in: range)

        var i = ranges.this.count + 1
        var j = ranges.other.count + 1

        let iterator = AnyIterator<Diff<Step>> {
            while i >= 1 && j >= 1 {
                switch matrix[i.hashValue, j.hashValue] {

                case matrix[i.hashValue, (j-1).hashValue]:
                    j = j - 1

                    let otherIndex = ranges.other.lowerBound.advanced(by: j - 1)
                    return .insert((otherIndex, other[otherIndex]))

                case matrix[(i-1).hashValue, j.hashValue]:
                    i = i - 1

                    let thisIndex = ranges.other.lowerBound.advanced(by: i - 1)
                    return .delete((thisIndex, self[thisIndex]))

                default:
                    i = i - 1
                    j = j - 1

                    guard i >= 1 && j >= 1 else { break }

                    let thisIndex = ranges.this.lowerBound.advanced(by: i - 1)
                    let otherIndex = ranges.other.lowerBound.advanced(by: j - 1)

                    guard self[thisIndex] != other[otherIndex] else { break }
                    return .update((otherIndex, other[otherIndex]))
                }
            }
            
            return nil
        }
        
        return (ranges, iterator)
    }

    /// Return an iterator of longest common subsquence (LCS) diffing results.
    ///
    /// - Parameters:
    ///     - other: a collection to compare with.
    ///     - range: a range for both collection to apply the algorithm on.
    ///       If `range` is `nil`, the operation will perform on the entire collections.
    func backtrackChanges<C>(byLCSComparing other: C, in range: Range<Index>? = nil) -> AnyIterator<Diff<Step>> where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.Iterator.Element: Equatable,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return _backtrackChanges(byLCSComparing: other, in: range).1
    }

    /// Return an array of longest common subsequence LCS) diffing results.
    ///
    /// - Parameters:
    ///     - other: a collection to compare with.
    ///     - range: a range for both collection to apply the algorithm on.
    ///       If `range` is `nil`, the operation will perform on the entire collections.
    func compareUsingLCS<C>(_ other: C, in range: Range<Index>? = nil) -> [Diff<Step>] where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.Iterator.Element: Equatable,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        let (ranges, changes) = _backtrackChanges(byLCSComparing: other, in: range)
        let count = Swift.max(ranges.this.count, ranges.other.count)

        var results: [Diff<Step>] = []
        results.reserveCapacity(count.hashValue)
        changes.forEach({ results.insert($0, at: 0) })

        return results
    }

    @available(*, deprecated, renamed: "compareUsingLCS(_:in:)")
    func compare<C>(_ other: C, in range: Range<Index>? = nil) -> [Diff<Step>] where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.Iterator.Element: Equatable,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return compareUsingLCS(other, in: range)
    }

    /// Return updating, deleting and inserting indexes of longest common subsequence (LCS) diffing
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
    func compareUsingLCS<C, T>(_ other: C, in range: Range<Index>? = nil, transformer: IndexTransformer<T>) -> (deletes: [T], inserts: [T], updates: [T]) where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.Iterator.Element: Equatable,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        let (_, changes) = _backtrackChanges(byLCSComparing: other, in: range)
        var inserts = [T](), deletes = [T](), updates = [T]()

        for change in changes {
            switch change.map({ transformer($0.index) }) {
            case .delete(let value): deletes.insert(value, at: 0)
            case .insert(let value): inserts.insert(value, at: 0)
            case .update(let value): updates.insert(value, at: 0)
            }
        }

        return (deletes, inserts, updates)
    }
}

public extension Collection where SubSequence.Iterator.Element: Equatable, Index == Int {

    @available(*, unavailable, renamed: "compareUsingLCS(_:in:transformer:)")
    func compareOptimallyUsingLCS<C, T>(_ other: C, in range: Range<Index>? = nil, transformer: IndexTransformer<T>) -> (deletes: [T], inserts: [T]) where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return ([], [])
    }

    @available(*, unavailable, renamed: "compareUsingLCS(_:in:transformer:)")
    func compareOptimally<C, T>(_ other: C, in range: Range<Index>? = nil, transformer: IndexTransformer<T>) -> (deletes: [T], inserts: [T]) where
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return ([], [])
    }

    @available(*, unavailable, renamed: "compareUsingLCS(_:in:transformer:)")
    func compareThoroughlyUsingLCS<C, T>(_ other: C, in range: Range<Index>? = nil, transformer: IndexTransformer<T>) -> (updates: [T], deletes: [T], inserts: [T]) where
        T: Comparable,
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return ([], [], [])
    }

    @available(*, unavailable, renamed: "compareUsingLCS(_:in:transformer:)")
    func compareThoroughly<C, T>(_ other: C, in range: Range<Index>? = nil, transformer: IndexTransformer<T>) -> (updates: [T], deletes: [T], inserts: [T]) where
        T: Comparable,
        C: Collection,
        C.Index == Index,
        C.Iterator.Element == Iterator.Element,
        C.SubSequence.Iterator.Element == SubSequence.Iterator.Element
    {
        return ([], [], [])
    }
}
