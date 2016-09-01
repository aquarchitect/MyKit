/*
 * GenericCollectionView.swift
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

public class GenericCollectionView<Model, Cell: UICollectionViewCell>: UICollectionView, UICollectionViewDataSource {

    // MARK: Property

    public private(set) var cellModels: [Model] = []

    public var cellRenderer: ((Cell, Model) -> Void)? {
        didSet { self.reloadData() }
    }

    // MARK: Initialization

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        super.register(Cell.self, forReuseIdentifier: String(Cell.self))
        super.dataSource = self
    }

    // MARK: Data Source

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModels.count
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(String(Cell.self), forIndexPath: indexPath).then {
            $0.tag = collectionView.serialize(indexPath)
            cellRenderer?($0 as! Cell, cellModels[indexPath.item])
        }
    }
}

public extension GenericCollectionView {

    /**
     Apply changes to the state data set.
     */
    func apply(changes changes: [Change<Array<Model>.Step>], completion: AnimatingCompletion?) {
        let (deletes, inserts) = cellModels.apply(changes, inSection: 0)

        self.performBatchUpdates({
            self.deleteItemsAtIndexPaths(deletes)
            self.insertItemsAtIndexPaths(inserts)
            }, completion: completion)
    }
}

public extension GenericCollectionView where Model: Equatable {

    /**
     Render collection view rows with animation. If changes are not specified,
     collection view will compute the differences between 2 set and animate
     the changes accordingly.
     */
    func render(cellModels models: [Model], animated: Bool = true, completion: AnimatingCompletion? = nil) {
        guard cellModels != models else { return }

        if !animated {
            cellModels = models
            self.reloadData()
            return
        }

        let indexes = (self.indexPathsForSelectedItems() ?? []).flatMap {
            $0.section == 0 ? nil : $0.item
            } ?? []

        let range: Range<Int>?
        if !indexes.isEmpty {
            let startIndex = indexes.minElement() ?? 0
            let endIndex = indexes.maxElement() ?? 0
            range = startIndex...endIndex
        } else {
            range = nil
        }

        let (deletes, inserts) = self.cellModels.compare(models, range: range, inSection: 0)
        cellModels = models

        self.performBatchUpdates({
            self.deleteItemsAtIndexPaths(deletes)
            self.insertItemsAtIndexPaths(inserts)
            }, completion: completion)
    }
}