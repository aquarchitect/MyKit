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

public class GenericCollectionController<Item, Cell: UICollectionViewCell>: UICollectionViewController {

    // MARK: Property

    public typealias CellRenderer = (Cell, Item) -> Void

    private var _collectionView: GenericCollectionView<Item, Cell>? {
        return collectionView as? GenericCollectionView<Item, Cell>
    }

    public var items: [Item] {
        return _collectionView?.items ?? []
    }

    public var cellRenderer: CellRenderer? {
        get { return _collectionView?.cellRenderer }
        set { _collectionView?.cellRenderer = newValue }
    }

    // MARK: View Lifecycle

    public override func loadView() {
        collectionView = GenericCollectionView<Item, Cell>(frame: .zero, collectionViewLayout: self.collectionViewLayout)
    }
}

public extension GenericCollectionController {

    /**
     Apply changes to the state data set.

     - parameter automatic: if true collection view will handle animation according to the changes; if false you gain back animation control.
     */
    func applyToCollectionView<G: GeneratorType where G.Element == Change<Array<Item>.Step>>(changes: G, automatic flag: Bool = true, completion: UIView.AnimatingCompletion?) {
        _collectionView?.apply(changes, automatic: flag, completion: completion)
    }
}

public extension GenericCollectionController {

    /**
     Render collection view rows with new states without animation.

     This method is equivalent to `reloadData` of `UICollectionView`.
     */
    func renderCollectionViewStatically(items: [Item]) {
        _collectionView?.renderStatically(items)
    }
}

public extension GenericCollectionController where Item: Equatable {

    /**
     Render collection view rows with new states with animation.

     This method uses __LCS__ (Longest Common Sequence) under the hood
     to figure out the differences between 2 data set, and
     render table view accordingly.
     */
    func renderCollectionViewDynamically(items: [Item], completion: UIView.AnimatingCompletion?) {
        _collectionView?.renderDynamically(items, completion: completion)
    }
}
