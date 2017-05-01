// 
// UICollectionView+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import UIKit

// MARK: - Miscellaneous

/// :nodoc:
public extension UICollectionView {

    final func hasSection(section: Int) -> Bool {
        return 0..<self.numberOfSections ~= section
    }
}

// MARK: Transform IndexPath

public extension UICollectionView {

    final func indexPath(after indexPath: IndexPath) -> IndexPath? {
        if indexPath.item < self.numberOfItems(inSection: indexPath.section) - 1 {
            return IndexPath(item: indexPath.item + 1, section: indexPath.section)
        } else if indexPath.section < self.numberOfSections - 1 {
            return IndexPath(item: 0, section: indexPath.section + 1)
        } else { return nil }
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

    final func index(bySerializing indexPath: IndexPath) -> Int {
        return (0..<indexPath.section)
            .map(self.numberOfItems(inSection:))
            .lazy
            .reduce(indexPath.row, +)
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
}
