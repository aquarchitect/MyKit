/*
 * GenericCollectionView.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

public class GenericCollectionView<Model, Cell: UICollectionViewCell>: UICollectionView, UICollectionViewDataSource {

    // MARK: Property

    public fileprivate(set) var cellModels: [Model] = []

    /*
     * Providing an estimated of number of visible row will
     * speed up the diff computation.
     *
     * Unlike table view, it is impossible to calculate a 
     * possible range for diff computation because of the
     * nature of dynamic cell layout.
     */
    public var estimatedNumberOfVisibleCells = 0

    public var cellRenderer: ((Cell, Model) -> Void)? {
        didSet { self.reloadData() }
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

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModels.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "\(type(of: Cell.self))", for: indexPath).then {
            cellRenderer?($0 as! Cell, cellModels[indexPath.item])
        }
    }
}

public extension GenericCollectionView where Model: Equatable {

    func render(cellModels: [Model], update: Update) {
        switch update {
        case .lscWithAnimation(let completion):
            let range: CountableRange<Int> = {
                let startIndex = self.indexPathsForVisibleItems.first?.item ?? 0
                let endIndex = startIndex + estimatedNumberOfVisibleCells
                return .init(startIndex ... endIndex)
            }()

            let updates = cellModels.compare(cellModels, range: range, section: 0)
            self.cellModels = cellModels

            self.performBatchUpdates({
                self.reloadItems(at: updates.reloads)
                self.deleteItems(at: updates.deletes)
                self.insertItems(at: updates.inserts)
                }, completion: completion)
        case .manualHandling(let handle):
            self.cellModels = cellModels
            handle(self)
        }
    }
}
