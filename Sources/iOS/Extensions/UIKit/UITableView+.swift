// 
// UITableView+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import UIKit

// MARK: - Miscellaneous

/// :nodoc:
public extension UITableView {

    var bottomedIndexPath: IndexPath {
        let section = self.numberOfSections - 1
        let row = self.numberOfRows(inSection: section)

        return .init(row: row, section: section)
    }

    var estimatedNumberOfVisibleRows: Int {
        if self.estimatedRowHeight == 0 {
            return Int(self.bounds.height/self.rowHeight)
        } else {
            return Int(self.bounds.height/self.estimatedRowHeight)
        }
    }

    var estimatedRangeOfVisibleRows: CountableRange<Int> {
        let lowerBound = self.indexPathsForVisibleRows?.first?.row ?? 0
        return lowerBound ..< (lowerBound + estimatedNumberOfVisibleRows)
    }

    final func hasSection(section: Int) -> Bool {
        return 0..<self.numberOfSections ~= section
    }
}

// MARK: - Transform IndexPath

public extension UITableView {

    final func indexPath(after indexPath: IndexPath) -> IndexPath? {
        if indexPath.row < self.numberOfRows(inSection: indexPath.section) - 1 {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        } else if indexPath.section < self.numberOfSections - 1 {
            return IndexPath(row: 0, section: indexPath.section + 1)
        } else { return nil }
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

    final func index(bySerializing indexPath: IndexPath) -> Int {
        return (0..<indexPath.section)
            .map(self.numberOfRows(inSection:))
            .lazy
            .reduce(indexPath.row, +)
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
}
