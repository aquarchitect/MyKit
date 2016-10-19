/*
 * UICollectionView+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

public extension UICollectionView {

    enum Update {
#if swift(>=3.0)
        case lcs, forcefull
#else
        case LCS, Forcefull
#endif
    }
}

// MARK: - Miscellaneous

/// :nodoc:
public extension UICollectionView {

#if swift(>=3.0)
    final func hasSection(section: Int) -> Bool {
        return 0..<self.numberOfSections ~= section
    }
#else
    final func hasSection(section: Int) -> Bool {
        return 0..<self.numberOfSections() ~= section
    }
#endif
}

// MARK: Transform IndexPath

public extension UICollectionView {

#if swift(>=3.0)
    final func indexPath(after indexPath: IndexPath) -> IndexPath? {
        if indexPath.item < self.numberOfItems(inSection: indexPath.section) - 1 {
            return IndexPath(item: indexPath.item + 1, section: indexPath.section)
        } else if indexPath.section < self.numberOfSections - 1 {
            return IndexPath(item: 0, section: indexPath.section + 1)
        } else { return nil }
    }

    @available(*, unavailable, renamed: "indexPath(after:)")
    final func successorOfIndexPath(_ indexPath: IndexPath) -> IndexPath? {
        return self.indexPath(after: indexPath)
    }

    final func indexPath(before indexPath: IndexPath) -> IndexPath? {
        if indexPath.item > 0 {
            return IndexPath(item: indexPath.item - 1, section: indexPath.section)
        } else if indexPath.section > 0 {
            let section = indexPath.section - 1
            let item = self.numberOfItems(inSection: section) - 1

            return IndexPath(item: item, section: section)
        } else { return nil }
    }

    @available(*, unavailable, renamed: "indexPath(before:)")
    final func predecessorOfIndexPath(_ indexPath: IndexPath) -> IndexPath? {
        return self.indexPath(before: indexPath)
    }

    final func index(bySerializing indexPath: IndexPath) -> Int {
        return (0..<indexPath.section)
            .map(self.numberOfItems(inSection:))
            .lazy
            .reduce(indexPath.row, +)
    }

    @available(*, unavailable, renamed: "index(bySerializing:)")
    final func indexBySerializingIndexPath(_ indexPath: IndexPath) -> Int {
        return self.index(bySerializing: indexPath)
    }

    final func indexPath(byDeserializing index: Int) -> IndexPath {
        var (section, count) = (0, 0)

        while case let rows = self.numberOfItems(inSection: section),
            count + rows < index {
            count += rows
            section += 1
        }

        return IndexPath(row: index - count, section: section)
    }

    @available(*, unavailable, renamed: "indexPath(byDeserializing:)")
    final func indexPathByDeserializingIndex(_ index: Int) -> IndexPath {
        return self.indexPath(byDeserializing: index)
    }
#else
    final func successorOfIndexPath(indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.item < self.numberOfItemsInSection(indexPath.section) - 1 {
            return NSIndexPath(forItem: indexPath.item + 1, inSection: indexPath.section)
        } else if indexPath.section < self.numberOfSections() - 1 {
            return NSIndexPath(forItem: 0, inSection: indexPath.section + 1)
        } else { return nil }
    }

    final func predecessorOfIndexPath(indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.item > 0 {
            return NSIndexPath(forItem: indexPath.item - 1, inSection: indexPath.section)
        } else if indexPath.section > 0 {
            let section = indexPath.section - 1
            let item = self.numberOfItemsInSection(section) - 1

            return NSIndexPath(forItem: item, inSection: section)
        } else { return nil }
    }

    final func indexBySerializingIndexPath(indexPath: NSIndexPath) -> Int {
        return (0..<indexPath.section)
            .map(self.numberOfItemsInSection)
            .lazy
            .reduce(indexPath.row, combine: +)
    }

    final func indexPathByDeserializingIndex(index: Int) -> NSIndexPath {
        var (section, count) = (0, 0)

        while case let rows = self.numberOfItemsInSection(section)
            where count + rows < index {
                count += rows
                section += 1
        }

        return NSIndexPath(forItem: index - count, inSection: section)
    }
#endif
}
