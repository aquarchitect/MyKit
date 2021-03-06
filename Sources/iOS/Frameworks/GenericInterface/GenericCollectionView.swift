//
// GenericCollectionView.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import UIKit

@available(*, deprecated)
open class GenericCollectionView<Model: Hashable, Cell: UICollectionViewCell>: UICollectionView, UICollectionViewDataSource {

    // MARK: Property

    // Providing an estimated of number of visible row will
    // speed up the diff computation.
    //
    // Unlike table view, it is impossible to calculate a
    // possible range for diff computation because of the
    // nature of dynamic cell layout.
    open var estimatedNumberOfVisibleCells = 0

    open var cellRenderer: ((Cell, Model) -> Void)? {
        didSet { self.reloadData() }
    }

    open fileprivate(set) var cellModels: [Model] = [] {
        didSet {
            let range: Range<Int>? = {
                guard estimatedNumberOfVisibleCells != 0 else { return nil }

                // the assumption is `indexPathsForVisibleItems` in an
                // ascending order.
                let startIndex = self.indexPathsForVisibleItems.first?.item ?? 0
                let endIndex = startIndex + estimatedNumberOfVisibleCells
                return Range(startIndex ... endIndex)
            }()

            let (deletes, inserts, updates) = oldValue.compareUsingLCS(
                cellModels, in: range,
                transformer: IndexPath(index: 0).appending
            )

            self.performBatchUpdates({
                self.deleteItems(at: deletes)
                self.insertItems(at: inserts)
            }, completion: { _ in
                self.reloadItems(at: updates)
            })
        }
    }

    // MARK: Initialization

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        super.register(Cell.self, forCellWithReuseIdentifier: "\(type(of: Cell.self))")
        super.dataSource = self
    }

    // MARK: Data Source

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModels.count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "\(type(of: Cell.self))", for: indexPath).then {
            cellRenderer?($0 as! Cell, cellModels[indexPath.item])
        }
    }
}
