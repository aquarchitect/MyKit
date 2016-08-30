/*
 * UITableView+.swift
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

// MARK: - Miscellaneous

/// :nodoc:
public extension UITableView {

    var bottomedIndexPath: NSIndexPath {
        let section = self.numberOfSections - 1
        let row = self.numberOfRowsInSection(section)
        return NSIndexPath(forRow: row, inSection: section)
    }

    final func validates(section section: Int) -> Bool {
        return NSLocationInRange(section, NSMakeRange(0, self.numberOfSections))
    }
}

// MARK: - Transform IndexPath

public extension UITableView {

    final func successorOf(indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.row < self.numberOfRowsInSection(indexPath.section) - 1 {
            return NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
        } else if indexPath.section < self.numberOfSections - 1 {
            return NSIndexPath(forRow: 0, inSection: indexPath.section + 1)
        } else { return nil }
    }

    final func predecessorOf(indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.row > 0 {
            return NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
        } else if indexPath.section > 0 {
            let section = indexPath.section - 1
            let row = self.numberOfRowsInSection(section) - 1

            return NSIndexPath(forRow: row, inSection: section)
        } else { return nil }
    }

    final func serialize(indexPath: NSIndexPath) -> Int {
        return (0..<indexPath.section)
            .map { self.numberOfRowsInSection($0) }
            .lazy
            .reduce(indexPath.row, combine: +)
    }

    final func deserialize(index: Int) -> NSIndexPath {
        var (section, count) = (0, 0)

        while case let rows = self.numberOfRowsInSection(section) where count + rows < index {
            count += rows
            section += 1
        }

        return NSIndexPath(forRow: index - count, inSection: section)
    }
}

// MARK: - Register Reusable View

public extension UITableView {

    final func register<T: UITableViewCell>(type: T.Type, forReuseIdentifier identifier: String) {
        self.registerClass(type, forCellReuseIdentifier: identifier)
    }

    final func register<T: UITableViewHeaderFooterView>(type: T.Type, forReuseIdentifier identifier: String) {
        self.registerClass(type, forHeaderFooterViewReuseIdentifier: identifier)
    }
}