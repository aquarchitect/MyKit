/*
 * GenericCollectionController.swift
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

public class GenericCollectionController<T, C: UICollectionViewCell>: UICollectionViewController {

    // MARK: Property

    public typealias Styling = (C, T) -> Void
    public private(set) var items: [T] = []

    public var styling: Styling? {
        didSet { collectionView?.reloadData() }
    }

    // MARK: View Lifecycle

    public override func loadView() {
        super.loadView()

        collectionView?.register(C.self, forReuseIdentifier: "Cell")
    }

    // MARK: Collection View Data Source

    public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
            .then { styling?($0 as! C, items[indexPath.item]) }
    }
}

public extension GenericCollectionController where T: Equatable {

    func styleCollectionView(newItems items: [T], automaticAnimation flag: Bool, completion: ((Bool) -> Void)?) {
        let oldItems = self.items
        self.items = items

        guard flag else { return }
        let (reloads, deletes, inserts) = oldItems.compare(items).updates
        let mapper = { NSIndexPath(forRow: $0, inSection: 0) }

        collectionView?.performBatchUpdates({ [unowned self] in
            self.collectionView?.then {
                $0.reloadItemsAtIndexPaths(reloads.map(mapper))
                $0.deleteItemsAtIndexPaths(deletes.map(mapper))
                $0.insertItemsAtIndexPaths(inserts.map(mapper))
            }
            }, completion: completion)
    }
}
