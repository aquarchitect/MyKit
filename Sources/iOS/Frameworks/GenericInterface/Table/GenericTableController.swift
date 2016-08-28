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

    public var styling: RowRenderer? {
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
            styling?($0 as! R, items[indexPath.row])
        }
    }
}

public extension GenericTableController where T: Equatable {

    func renderTableView(items: [T], update: UITableView.Update) {
        let oldItems = self.items
        self.items = items

        let changeGenerator: AnyGenerator<Change<Int>>
        switch update {
        case .Automatic: changeGenerator = oldItems.generateDiffIndexes(byComparing: items)
        case .Patch(let generator): changeGenerator = generator
        }

        var reloadIndexPaths: [NSIndexPath] = []
        var deleteIndexPaths: [NSIndexPath] = []
        var insertIndexPaths: [NSIndexPath] = []

        changeGenerator.forEach {
            switch ($0.then { NSIndexPath(forRow: $0, inSection: 0) }) {
            case .Reload(let value): reloadIndexPaths += [value]
            case .Delete(let value): deleteIndexPaths += [value]
            case .Insert(let value): insertIndexPaths += [value]
            }
        }

        tableView.then {
            $0.beginUpdates()
            $0.reloadRowsAtIndexPaths(reloadIndexPaths, withRowAnimation: .Automatic)
            $0.deleteRowsAtIndexPaths(deleteIndexPaths, withRowAnimation: .Automatic)
            $0.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .Automatic)
            $0.endUpdates()
        }
    }
}