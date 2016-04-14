//
//  CollecitonViewController.swift
//  MyKitDemo
//
//  Created by Hai Nguyen on 3/29/16.
//
//

final class CollectionViewController<C: UICollectionViewCell>: MyKit.CollectionViewController<Int, C> {

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .whiteColor()

        items = [Array(count: 200, repeatedValue: 0)]
        config = { cell, _ in cell.backgroundColor = .random() }
    }
}