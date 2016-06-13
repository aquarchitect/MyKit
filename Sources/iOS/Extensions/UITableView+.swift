/*
 * UITableView+.swift
 * MyKit
 *
 * Copyright (c) 2015–2016 Hai Nguyen
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

/// :nodoc:
public extension UITableView {

    // MARK: Miscellaneous

    final func isSectionValid(`in` section: Int) -> Bool {
        return NSLocationInRange(section, NSMakeRange(0, self.numberOfSections))
    }

    final func isRowBottomed(at indexPath: NSIndexPath) -> Bool {
        return indexPath.row ==  self.numberOfRowsInSection(indexPath.section) - 1
    }

    // MARK: Transform IndexPath

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

    // MARK: Register Views

    public func register<T: UITableViewCell>(type: T.Type, forReuseIdentifier identifier: String) {
        self.registerClass(type, forCellReuseIdentifier: identifier)
    }

    public func register<T: UITableViewHeaderFooterView>(type: T.Type, forReuseIdentifier identifier: String) {
        self.registerClass(type, forHeaderFooterViewReuseIdentifier: identifier)
    }
}