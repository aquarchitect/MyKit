//
//  CollectionGenericView.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/26/15.
//  
//

import UIKit

public class CollectionGenericView<T, C: UICollectionViewCell>: UICollectionView, UICollectionViewDataSource {

    // MARK: Property

    public var items: [[T]] = []
    public var config: ((C, T) -> Void)?

    // MARK: Initialization

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        super.register(C.self, forReuseIdentifier: "Cell")
        super.dataSource = self
    }

    // MARK: Data Source

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return items.count
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath).then {
            config?($0 as! C, items[indexPath.section][indexPath.item])
        }
    }
}