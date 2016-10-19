/*
 * UITableView+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

public extension UITableView {

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
public extension UITableView {

#if swift(>=3.0)
    var bottomedIndexPath: IndexPath {
        let section = self.numberOfSections - 1
        let row = self.numberOfRows(inSection: section)

        return .init(row: row, section: section)
    }

    var estimatedNumberOfVisibleRows: Int {
        let height: CGFloat

        if self.visibleCells.isEmpty {
            height = UIScreen.main.bounds.height
        } else if self.estimatedRowHeight == 0 {
            height = self.bounds.height
        } else {
            height = self.estimatedRowHeight
        }

        return Int(height/self.rowHeight)
    }
#else
    var bottomedIndexPath: NSIndexPath {
        let section = self.numberOfSections - 1
        let row = self.numberOfRowsInSection(section)

        return .init(forRow: row, inSection: section)
    }

    var estimatedNumberOfVisibleRows: Int {
        let height: CGFloat

        if self.visibleCells.isEmpty {
            height = UIScreen.mainScreen().bounds.height
        } else if self.estimatedRowHeight == 0 {
            height = self.bounds.height
        } else {
            height = self.estimatedRowHeight
        }

        return Int(height/self.rowHeight)
    }
#endif

    final func hasSection(section: Int) -> Bool {
        return 0..<self.numberOfSections ~= section
    }
}

// MARK: - Transform IndexPath

public extension UITableView {

#if swift(>=3.0)
    final func indexPath(after indexPath: IndexPath) -> IndexPath? {
        if indexPath.row < self.numberOfRows(inSection: indexPath.section) - 1 {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        } else if indexPath.section < self.numberOfSections - 1 {
            return IndexPath(row: 0, section: indexPath.section + 1)
        } else { return nil }
    }

    @available(*, unavailable, renamed: "indexPath(after:)")
    final func successorOfIndexPath(_ indexPath: IndexPath) -> IndexPath? {
        return self.indexPath(after: indexPath)
    }

    final func indexPath(before indexPath: IndexPath) -> IndexPath? {
        if indexPath.row > 0 {
            return IndexPath(row: indexPath.row - 1, section: indexPath.section)
        } else if indexPath.section > 0 {
            let section = indexPath.section - 1
            let row = self.numberOfRows(inSection: section) - 1

            return IndexPath(row: row, section: section)
        } else { return nil }
    }

    @available(*, unavailable, renamed: "indexPath(before:)")
    final func predecessorOfIndexPath(_ indexPath: IndexPath) -> IndexPath? {
        return self.indexPath(before: indexPath)
    }

    final func index(bySerializing indexPath: IndexPath) -> Int {
        return (0..<indexPath.section)
            .map(self.numberOfRows(inSection:))
            .lazy
            .reduce(indexPath.row, +)
    }

    @available(*, unavailable, renamed: "index(bySerializing:)")
    final func indexBySerializingIndexPath(_ indexPath: IndexPath) -> Int {
        return self.index(bySerializing: indexPath)
    }

    final func indexPath(byDeserializing index: Int) -> IndexPath {
        var (section, count) = (0, 0)

        while case let rows = self.numberOfRows(inSection: section),
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
        if indexPath.row < self.numberOfRowsInSection(indexPath.section) - 1 {
            return NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
        } else if indexPath.section < self.numberOfSections - 1 {
            return NSIndexPath(forRow: 0, inSection: indexPath.section + 1)
        } else { return nil }
    }

    final func predecessorOfIndexPath(indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.row > 0 {
            return NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
        } else if indexPath.section > 0 {
            let section = indexPath.section - 1
            let row = self.numberOfRowsInSection(section) - 1

            return NSIndexPath(forRow: row, inSection: section)
        } else { return nil }
    }

    final func indexBySerializing(indexPath: NSIndexPath) -> Int {
        return (0..<indexPath.section)
            .map(self.numberOfRowsInSection)
            .lazy
            .reduce(indexPath.row, combine: +)
    }

    final func indexPathByDeserializingIndex(index: Int) -> NSIndexPath {
        var (section, count) = (0, 0)

        while case let rows = self.numberOfRowsInSection(section)
            where count + rows < index {
                count += rows
                section += 1
        }

        return NSIndexPath(forRow: index - count, inSection: section)
    }
#endif
}
