/*
 * GenericTableController.swift
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

public class GenericTableController<T, R: UITableViewCell>: UITableViewController {

    // MARK: Property

    public typealias RowRenderer = (R, T) -> Void
    public private(set) var items: [T] = []

    public var rowRenderer: RowRenderer? {
        didSet { tableView.reloadData() }
    }

    // MARK: View Lifecycle

    public override func loadView() {
        super.loadView()

        tableView.then {
            $0.showsHorizontalScrollIndicator = false
            $0.register(R.self, forReuseIdentifier: String(R.self))
        }
    }

    // MARK: Table View Data Source

    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(String(R.self), forIndexPath: indexPath).then {
            $0.tag = tableView.serialize(indexPath)
            rowRenderer?($0 as! R, items[indexPath.row])
        }
    }
}

public extension GenericTableController {

    /**
     Apply changes to the state data set.

     - parameter automatic: if true table view will handle animation according to the changes; if false you gain back animation control.
     */
    func applyToTableView(changes: [Change<Array<T>.Step>], automatic flag: Bool = true) {
        self.items.apply(changes)

        guard flag else { return }
        let patch = changes.lazy.map { $0.then { $0.index }}
        tableView.update(patch.generate(), inSection: 0)
    }
}

public extension GenericTableController {

    /**
     Render table view rows with new states without animation.

     This method is equivalent to `reloadData` of `UITableView`.
     */
    func renderTableViewStatically(items: [T]) {
        self.items = items
        tableView.reloadData()
    }
}

public extension GenericTableController where T: Equatable {

    /**
     Render table view rows with new states with animation.

     This method uses __LCS__ (Longest Common Sequence) under the hood
     to figure out the difference between 2 data set, and
     render table view accordingly.
     */
    func renderTableViewDynamically(items: [T]) {
        let changes = self.items.compare(byComparing: items)
        self.items = items

        let patch = changes.lazy.map { $0.then { $0.index }}
        tableView.update(patch.generate(), inSection: 0)
    }
}