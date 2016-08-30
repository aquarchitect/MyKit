/*
 * GenericTableView.swift
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

public class GenericTableView<Item, Row: UITableViewCell>: UITableView, UITableViewDataSource {

    // MARK: Property

    public typealias RowRenderer = (Row, Item) -> Void
    public private(set) var items: [Item] = []

    public var rowRenderer: RowRenderer? {
        didSet { self.reloadData() }
    }

    // MARK: Initialization

    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        super.showsHorizontalScrollIndicator = false
        super.register(Row.self, forReuseIdentifier: String(Row.self))
        super.dataSource = self
    }

    // MARK: Table View Data Source

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(String(Row.self), forIndexPath: indexPath).then {
            $0.tag = tableView.serialize(indexPath)
            rowRenderer?($0 as! Row, items[indexPath.row])
        }
    }
}

public extension GenericTableView {

    /**
     Apply changes to the state data set.

     - parameter automatic: if true table view will handle animation according to the changes; if false you gain back animation control.
     */
    func apply<G: GeneratorType where G.Element == Change<Array<Item>.Step>>(changes: G, automatic flag: Bool = true) {
        let indexPathMapper = { NSIndexPath(forRow: $0, inSection: 0) }

        var deleteIndexPaths: [NSIndexPath] = []
        var insertIndexPaths: [NSIndexPath] = []

        AnyGenerator(changes).forEach {
            switch $0 {
            case .Delete(let index, _):
                deleteIndexPaths += [index].map(indexPathMapper)
                self.items.removeAtIndex(index)
            case .Insert(let index, let element):
                insertIndexPaths += [index].map(indexPathMapper)
                self.items.insert(element, atIndex: index)
            }
        }

        guard flag else { return }
        self.beginUpdates()
        self.deleteRowsAtIndexPaths(deleteIndexPaths, withRowAnimation: .Automatic)
        self.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .Automatic)
        self.endUpdates()
    }
}

public extension GenericTableView {

    /**
     Render table view rows with new states without animation.

     This method is equivalent to `reloadData` of `UITableView`.
     */
    func renderStatically(items: [Item]) {
        self.items = items
        self.reloadData()
    }
}

public extension GenericTableView where Item: Equatable {

    /**
     Render table view rows with new states with animation.
     
     This method uses __LCS__ (Longest Common Sequence) under the hood
     to figure out the difference between 2 data set, and
     render table view accordingly.
     */
    func renderDynamically(items: [Item]) {
        let indexPathMapper = { NSIndexPath(forRow: $0, inSection: 0) }

        var deleteIndexPaths: [NSIndexPath] = []
        var insertIndexPaths: [NSIndexPath] = []

        self.items.enumerateReversedChanges(byComparing: items) {
            let change = $0
                .then { $0.index }
                .then(indexPathMapper)
            switch change {
            case .Delete(let indexPath): deleteIndexPaths.insert(indexPath, atIndex: 0)
            case .Insert(let indexPath): insertIndexPaths.insert(indexPath, atIndex: 0)
            }
        }

        self.items = items

        self.beginUpdates()
        self.deleteRowsAtIndexPaths(deleteIndexPaths, withRowAnimation: .Automatic)
        self.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .Automatic)
        self.endUpdates()
    }
}