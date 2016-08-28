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

    public typealias CellRenderer = (C, T) -> Void
    public private(set) var items: [T] = []

    public var cellRenderer: CellRenderer? {
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
        return collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath).then {
            $0.tag = collectionView.serialize(indexPath)
            cellRenderer?($0 as! C, items[indexPath.item])
        }
    }
}

public extension GenericCollectionController where T: Equatable {

    func renderCollectionView(items: [T], update: UICollectionView.Update, completion: ((Bool) -> Void)?) {
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

        collectionView?.performBatchUpdates({ [unowned self] in
            self.collectionView?.then {
                $0.reloadItemsAtIndexPaths(reloadIndexPaths)
                $0.deleteItemsAtIndexPaths(deleteIndexPaths)
                $0.insertItemsAtIndexPaths(insertIndexPaths)
            }
            }, completion: completion)
    }
}
