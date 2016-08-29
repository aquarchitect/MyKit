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

public class GenericCollectionController<S, C: UICollectionViewCell>: UICollectionViewController {

    // MARK: Property

    public typealias CellRenderer = (C, S) -> Void
    public private(set) var cellStates: [S] = []

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
        return cellStates.count
    }

    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath).then {
            $0.tag = collectionView.serialize(indexPath)
            cellRenderer?($0 as! C, cellStates[indexPath.item])
        }
    }
}

public extension GenericCollectionController where S: Equatable {

    func renderCollectionView(cellStates: [S], completion: UIView.AnimatingCompletion?) {
        let changes = self.cellStates.compare(byComparing: cellStates)
        self.cellStates = cellStates

        let patch = changes.lazy.map { $0.then { $0.index }}
        collectionView?.update(patch.generate(), inSection: 0, completion: completion)
    }

    func applyToCollectionView(changes: [Change<Array<S>.Step>], automaticAnimation flag: Bool = true, completion: UIView.AnimatingCompletion?) {
        self.cellStates.apply(changes)

        guard flag else { return }
        let patch = changes.lazy.map { $0.then { $0.index }}
        collectionView?.update(patch.generate(), inSection: 0, completion: completion)
    }
}
