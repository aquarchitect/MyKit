/*
 * UITableView+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

// MARK: - Miscellaneous

/// :nodoc:
public extension UITableView {

    var bottomedIndexPath: IndexPath {
        let section = self.numberOfSections - 1
        let row = self.numberOfRows(inSection: section)

        return .init(row: row, section: section)
    }

    final func hasSection(section: Int) -> Bool {
        return 0..<self.numberOfSections ~= section
    }
}

public extension UITableView {

    enum Update {

        case lscWithAnimation(UITableViewRowAnimation)
        case manualHandling((UITableView) -> Void)
    }
}

// MARK: - Transform IndexPath

public extension UITableView {

    final func formIndexPath(after indexPath: IndexPath) -> IndexPath? {
        if indexPath.row < self.numberOfRows(inSection: indexPath.section) - 1 {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        } else if indexPath.section < self.numberOfSections - 1 {
            return IndexPath(row: 0, section: indexPath.section + 1)
        } else { return nil }
    }

    final func formIndexPath(before indexPath: IndexPath) -> IndexPath? {
        if indexPath.row > 0 {
            return IndexPath(row: indexPath.row - 1, section: indexPath.section)
        } else if indexPath.section > 0 {
            let section = indexPath.section - 1
            let row = self.numberOfRows(inSection: section) - 1

            return IndexPath(row: row, section: section)
        } else { return nil }
    }

    final func serialize(indexPath: NSIndexPath) -> Int {
        return (0..<indexPath.section)
            .map { self.numberOfRows(inSection: $0) }
            .lazy
            .reduce(indexPath.row, +)
    }

    final func deserialize(index: Int) -> IndexPath {
        var (section, count) = (0, 0)

        while case let rows = self.numberOfRows(inSection: section),
            count + rows < index {
            count += rows
            section += 1
        }

        return IndexPath(row: index - count, section: section)
    }
}
