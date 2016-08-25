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

public class GenericTableView<T, C: UITableViewCell>: UITableView, UITableViewDataSource {

    // MARK: Property

    public typealias Styling = (C, T) -> Void
    public private(set) var items: [T] = []

    public var styling: Styling? {
        didSet { self.reloadData() }
    }

    // MARK: Initialization

    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        super.showsHorizontalScrollIndicator = false
        super.register(C.self, forReuseIdentifier: String(C.self))
        super.dataSource = self
    }

    // MARK: Table View Data Source

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(String(C.self), forIndexPath: indexPath).then {
            styling?($0 as! C, items[indexPath.row])
        }
    }
}

public extension GenericTableView where T: Equatable {

    func style(newItems items: [T], automaticAnimation flag: Bool) {
        let oldItems = self.items
        self.items = items

        guard flag else { return }
        let (reloads, deletes, inserts) = oldItems.compare(items).updates
        let mapper = { NSIndexPath(forRow: $0, inSection: 0) }

        self.beginUpdates()
        self.reloadRowsAtIndexPaths(reloads.map(mapper), withRowAnimation: .Automatic)
        self.deleteRowsAtIndexPaths(deletes.map(mapper), withRowAnimation: .Automatic)
        self.insertRowsAtIndexPaths(inserts.map(mapper), withRowAnimation: .Automatic)
        self.endUpdates()
    }
}