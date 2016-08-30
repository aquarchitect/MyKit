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

public class GenericTableController<Item, Row: UITableViewCell>: UITableViewController {

    // MARK: Property

    public typealias RowRenderer = (Row, Item) -> Void

    private var _tableView: GenericTableView<Item, Row>? {
        return tableView as? GenericTableView<Item, Row>
    }

    public var items: [Item] {
        return _tableView?.items ?? []
    }

    public var rowRenderer: RowRenderer? {
        get { return _tableView?.rowRenderer }
        set { _tableView?.rowRenderer = newValue }
    }

    // MARK: View Lifecycle

    public override func loadView() {
        tableView = GenericTableView<Item, Row>(frame: .zero, style: .Plain)
    }
}

public extension GenericTableController {

    /**
     Apply changes to the state data set.

     - parameter automatic: if true table view will handle animation according to the changes; if false you gain back animation control.
     */
    func applyToTableView<G: GeneratorType where G.Element == Change<Array<Item>.Step>>(changes: G, automatic flag: Bool = true) {
        _tableView?.apply(changes, automatic: flag)
    }
}

public extension GenericTableController {

    /**
     Render table view rows with new states without animation.

     This method is equivalent to `reloadData` of `UITableView`.
     */
    func renderTableViewStatically(items: [Item]) {
        _tableView?.renderStatically(items)
    }
}

public extension GenericTableController where Item: Equatable {

    /**
     Render table view rows with new states with animation.

     This method uses __LCS__ (Longest Common Sequence) under the hood
     to figure out the difference between 2 data set, and
     render table view accordingly.
     */
    func renderTableViewDynamically(items: [Item]) {
        _tableView?.renderDynamically(items)
    }
}