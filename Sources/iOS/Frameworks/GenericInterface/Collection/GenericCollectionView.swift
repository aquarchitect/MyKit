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

public class GenericCollectionView<S, C: UICollectionViewCell>: UICollectionView, UICollectionViewDataSource {

    // MARK: Property

    public typealias CellRenderer = (C, S) -> Void
    public private(set) var cellStates: [S] = []

    public var cellRenderer: CellRenderer? {
        didSet { self.reloadData() }
    }

    // MARK: Initialization

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        super.register(C.self, forReuseIdentifier: String(C.self))
        super.dataSource = self
    }

    // MARK: Data Source

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellStates.count
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(String(C.self), forIndexPath: indexPath).then {
            $0.tag = collectionView.serialize(indexPath)
            cellRenderer?($0 as! C, cellStates[indexPath.item])
        }
    }
}

public extension GenericCollectionView where S: Equatable {

    func render(cellStates: [S], completion: AnimatingCompletion?) {
        let changes = self.cellStates.compare(byComparing: cellStates)
        self.cellStates = cellStates

        let patch = changes.lazy.map { $0.then { $0.index }}
        update(patch.generate(), inSection: 0, completion: completion)
    }

    func apply(changes: [Change<Array<S>.Step>], automaticAnimation flag: Bool = true, completion: AnimatingCompletion?) {
        self.cellStates.apply(changes)

        guard flag else { return }
        let patch = changes.lazy.map { $0.then { $0.index }}
        update(patch.generate(), inSection: 0, completion: completion)
    }
}