/*
 * UICollectionView+.swift
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

import UIKit

public extension UICollectionView {

    enum Update {

        case lscWithAnimation(UIView.AnimatingCompletion)
        case manualHandling((UICollectionView) -> Void)
    }
}

// MARK: - Miscellaneous

/// :nodoc:
public extension UICollectionView {

    final func hasSection(section: Int) -> Bool {
        return 0..<self.numberOfSections ~= section
    }
}

// MARK: Transform IndexPath

public extension UICollectionView {

    final func formIndexPath(after indexPath: IndexPath) -> IndexPath? {
        if indexPath.item < self.numberOfItems(inSection: indexPath.section) - 1 {
            return IndexPath(item: indexPath.item + 1, section: indexPath.section)
        } else if indexPath.section < self.numberOfSections - 1 {
            return IndexPath(item: 0, section: indexPath.section + 1)
        } else { return nil }
    }

    final func formIndexPath(before indexPath: IndexPath) -> IndexPath? {
        if indexPath.item > 0 {
            return IndexPath(item: indexPath.item - 1, section: indexPath.section)
        } else if indexPath.section > 0 {
            let section = indexPath.section - 1
            let item = self.numberOfItems(inSection: section) - 1

            return IndexPath(item: item, section: section)
        } else { return nil }
    }

    final func serialize(indexPath: IndexPath) -> Int {
        return (0..<indexPath.section)
            .map { self.numberOfItems(inSection: $0) }
            .lazy
            .reduce(indexPath.row, +)
    }

    final func deserialize(index: Int) -> IndexPath {
        var (section, count) = (0, 0)

        while case let rows = self.numberOfItems(inSection: section),
            count + rows < index {
            count += rows
            section += 1
        }

        return IndexPath(row: index - count, section: section)
    }
}
